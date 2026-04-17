class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :set_post, only: %i[ toggle_favourite toggle_like toggle_reaction show edit update destroy ]

  def index
    # @posts = Post.all
    @posts = Post.paginate(page: params[:page])
  end

  def by_tag
    @posts = Post.tagged_with(params[:tag])
    render :index
  end

  def favourites
    @posts = current_user.favourites
    render :index
  end

  def toggle_favourite
    favourite_post = FavouritePost.where(user_id: current_user.id, post_id: @post.id)

    if favourite_post.any?
      favourite_post.destroy_all
    else
      FavouritePost.create(user_id: current_user.id, post_id: @post.id)
    end

    # redirect_back fallback_location: posts_path
    render :replace_post
  end

  def toggle_like
    liked_post = Like.where(user_id: current_user.id, likeable_type: 'Post', likeable_id: @post.id)

    if liked_post.any?
      liked_post.destroy_all
    else
      Like.create(user_id: current_user.id, likeable_type: 'Post', likeable_id: @post.id)
    end

    # redirect_back fallback_location: posts_path
    render :replace_post
  end

  def toggle_reaction
    reaction = Reaction.where(user_id: current_user.id, post_id: @post.id, kind: params[:kind])

    if reaction.any?
      reaction.destroy_all
    else
      Reaction.create(user_id: current_user.id, post_id: @post.id, kind: params[:kind])
    end

    # redirect_back fallback_location: posts_path
    render :replace_post
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    def set_post
      @post = Post.find(params.expect(:id))
    end

    def post_params
      params.expect(post: [ :title, :body, :author, :cover, :tag_list, :category_list ])
    end
end
