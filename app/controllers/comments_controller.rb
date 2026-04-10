class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_post, only: %i[ create destroy ]

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
