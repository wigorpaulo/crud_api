class ApplicationController < ActionController::API
  before_action :authenticate_request!

  private

  def authenticate_request!
    token = request.headers['Authorization']

    if token.present?
      begin
        unless token.split.first == 'Bearer'
          return render json: { error: I18n.t('token.type_invalid') }, status: :unauthorized
        end

        decode_token = JWT.decode(token.split.last, Rails.application.secret_key_base)
        user_id = decode_token[0]['user_id']

        @current_user = User.find(user_id)
      rescue JWT::VerificationError, JWT::DecodeError, JWT::ExpiredMessage, ActiveRecord::RecordNotFound => e
        message = e.message == 'Signature has expired' ? I18n.t('token.expired') : e.message
        render json: { errors: [message] }, status: :unauthorized
      end
    else
      render json: { error: I18n.t('token.not_provided') }, status: :unauthorized
    end
  end

  attr_reader :current_user
end
