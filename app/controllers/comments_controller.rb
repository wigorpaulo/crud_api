class CommentsController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[index show create update destroy]
  before_action :set_comment, only: %i[show update destroy]

  # GET /comments
  def index
    @comments = Comment.includes(post: [:user]).all

    render json: @comments
  end

  # GET /comments/1
  def show
    render json: @comment, status: :ok
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    render json: @comment, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.includes(post: [:user]).find(params[:id])
  rescue StandardError
    render json: { errors: I18n.t('record.not_found',
                                  model: I18n.t('activerecord.models.comment'),
                                  id: params[:id]) },
           status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:id, :name, :text, :post_id)
  end
end
