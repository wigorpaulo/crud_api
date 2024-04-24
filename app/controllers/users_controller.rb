class UsersController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[index show create_token]
  before_action :valid_params, only: [:create_token]
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET / users/1
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    render json: @user, status: :ok
  end

  def create_token
    user = User.find_by(email: params[:email])

    unless user.present? && user.authenticate(params[:password])
      return render json: { error: I18n.t('create_token.email_or_password_not_match') },
                    status: :unauthorized
    end

    render json: { token: generate_token(user), expires_in: 120.seconds, token_type: 'Bearer' },
           status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue StandardError
    render json: { errors: I18n.t('record.not_found',
                                  model: I18n.t('activerecord.models.user'),
                                  id: params[:id]) },
           status: :not_found
  end

  def user_params
    params.require(:user).permit(:id, :name, :email, :password)
  end

  def generate_token(user)
    JWT.encode({ user_id: user.id, exp: 120.seconds.from_now.to_i }, Rails.application.secret_key_base)
  end

  def valid_params
    unless params[:email].present?
      return render json: { error: I18n.t('create_token.email_not_present') }, status: :unauthorized
    end

    return if params[:password].present?

    render json: { error: I18n.t('create_token.password_not_present') }, status: :unauthorized
  end
end
