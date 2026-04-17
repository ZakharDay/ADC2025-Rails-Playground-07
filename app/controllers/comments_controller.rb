class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:toggle_like, :create, :destroy]
  before_action :set_post, only: %i[ create destroy ]

  def toggle_like
    @comment = Comment.find(params[:id])
    liked_post = Like.where(user_id: current_user.id, likeable_type: 'Comment', likeable_id: @comment.id)

    if liked_post.any?
      liked_post.destroy_all
    else
      Like.create(user_id: current_user.id, likeable_type: 'Comment', likeable_id: @comment.id)
    end
  end

  def create
    @comment = current_user.comments.new(params[:comment].permit(:body))
    @comment.post_id = @post.id

    # @comment = @post.comments.create(params[:comment].permit(:body))
    if @comment.save
      redirect_to post_path(@post)
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

  private
  
    def set_post
      @post = Post.find(params[:post_id])
    end

end
