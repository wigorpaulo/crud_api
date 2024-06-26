class PostsController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[index show]
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
    @post.user = @current_user

    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    render json: @post, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.includes(:user).find(params[:id])
  rescue StandardError
    render json: { error: I18n.t('record.not_found',
                                 model: I18n.t('activerecord.models.post'),
                                 id: params[:id]) },
           status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:id, :title, :text, :user_id)
  end
end
