class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy like unlike ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])

    unless viewed_post?(@post)
      @post.increment_views
      mark_post_as_viewed(@post)
    end
  end

  

  def viewed_post?(post)
    session[:viewed_posts] ||= []
    session[:viewed_posts].include?(post.id)
  end

  def mark_post_as_viewed(post)
    session[:viewed_posts] << post.id
  end

  def like
    unless liked_post?(@post)
      @post.increment_likes
      mark_post_as_liked(@post)
      respond_to do |format|
        format.html { redirect_to post_url(@post), notice: "You liked this post." }
        format.json { render :show, status: :ok, location: @post }
        format.js   # Добавляем поддержку JS
      end
    else
      respond_to do |format|
        format.html { redirect_to post_url(@post), alert: "You have already liked this post." }
        format.json { render :show, status: :unprocessable_entity, location: @post }
        format.js   # Добавляем поддержку JS
      end
    end
  end

  # DELETE /posts/1/unlike
  def unlike
    if liked_post?(@post)
      @post.decrement_likes
      unmark_post_as_liked(@post)
      respond_to do |format|
        format.html { redirect_to post_url(@post), notice: "You unliked this post." }
        format.json { render :show, status: :ok, location: @post }
        format.js   # Добавляем поддержку JS
      end
    else
      respond_to do |format|
        format.html { redirect_to post_url(@post), alert: "You haven't liked this post yet." }
        format.json { render :show, status: :unprocessable_entity, location: @post }
        format.js   # Добавляем поддержку JS
      end
    end
  end

  def liked_post?(post)
    session[:liked_posts] ||= []
    session[:liked_posts].include?(post.id)
  end

  def mark_post_as_liked(post)
    session[:liked_posts] << post.id
  end

  def unmark_post_as_liked(post)
    session[:liked_posts].delete(post.id)
  end


  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
