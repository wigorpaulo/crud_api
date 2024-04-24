class PostsController < ApplicationController
  before_action :valid_params, only: %i[show update destroy]
  before_action :set_post, only: %i[show update destroy]

  # GET /posts
  def index
    @posts = Post.includes(:user).all

    render json: @posts, status: :ok
  end

  # GET /posts/1
  def show
    render json: @post, status: :ok
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: [@post.errors] }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: { errors: [@post.errors] }, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    if @post.destroy
      render json: @post, status: :ok
    else
      render json: { errors: [@post.errors] }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.includes(:user).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:id, :title, :text, :user_id)
  end

  def valid_params
    return if params[:id].to_i.positive?

    render json: { error: I18n.t('params.invalid') }, status: :bad_request
  end
end
