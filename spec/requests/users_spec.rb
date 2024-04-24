require 'rails_helper'

RSpec.describe '/users', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { JWT.encode({ user_id: user.id, exp: 5.seconds.from_now.to_i }, Rails.application.secret_key_base) }

  let!(:valid_headers) { { Authorization: "Bearer #{token}" } }

  describe 'GET /index' do
    context 'with user not authenticate' do
      before do
        get users_url
      end

      it 'response status ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /show' do
    context 'with user not authenticated' do
      let!(:user) { create(:user) }

      before do
        get user_url(user)
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end

    context 'with user not authenticated and params id is null' do
      before do
        get user_url('null')
      end

      it 'response status bad_request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('params.invalid')}/)
      end
    end
  end

  describe 'POST /create' do
    context 'with user authenticated and valid parameters' do
      before do
        post users_url, headers: valid_headers, params: { user: attributes_for(:user) }
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end

    context 'with user authenticated and invalid parameters' do
      before do
        post users_url, headers: valid_headers, params: { user: { email: nil } }
      end

      it 'response status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with header Authorization is token type error' do
      before do
        post users_url, headers: { Authorization: token }, params: { user: attributes_for(:user) }
      end

      it 'response status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('token.type_invalid')}/)
      end
    end

    context 'with header Authorization is token nil' do
      before do
        post users_url, headers: { Authorization: nil }, params: { user: attributes_for(:user) }
      end

      it 'response status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('token.not_provided')}/)
      end
    end

    context 'with user authenticate and expired token' do
      before do
        sleep(7.seconds)
        post users_url, headers: { Authorization: "Bearer #{token}" }, params: { user: attributes_for(:user) }
      end

      it 'response status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors].first).to match(/#{I18n.t('token.expired')}/)
      end
    end
  end

  describe 'PATCH /update' do
    let!(:user) { create(:user) }

    context 'with user authenticated and valid parameters' do
      before do
        patch user_url(user), headers: valid_headers, params: { user: { email: 'novo_email@gmail.com' } }
      end

      it 'response status ok' do
        expect(response).to be_successful
      end

      it 'renders a JSON response with the patch' do
        expect(response.content_type).to match('application/json')
      end
    end

    context 'with user authenticated and invalid parameters' do
      before do
        patch user_url(user), headers: valid_headers, params: { user: { password: nil } }
      end

      it 'response status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders a JSON response with the patch' do
        expect(response.content_type).to match('application/json')
      end
    end

    context 'with header Authorization is token type error' do
      before do
        patch user_url(user), headers: { Authorization: token }, params: { user: { email: 'novo_email@gmail.com' } }
      end

      it 'response status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('token.type_invalid')}/)
      end
    end

    context 'with header Authorization is token nil' do
      before do
        patch user_url(user), headers: { Authorization: nil }, params: { user: { email: 'novo_email@gmail.com' } }
      end

      it 'response status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('token.not_provided')}/)
      end
    end

    context 'with user authenticate and expired token' do
      before do
        sleep(7.seconds)
        patch user_url(user), headers: { Authorization: "Bearer #{token}" },
                              params: { user: { email: 'novo_email@gmail.com' } }
      end

      it 'response status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors].first).to match(/#{I18n.t('token.expired')}/)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with user authenticated' do
      let!(:user) { create(:user) }

      before do
        delete user_url(user), headers: valid_headers
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end

    context 'with header Authorization is token type error' do
      before do
        delete user_url(user), headers: { Authorization: token }
      end

      it 'response status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('token.type_invalid')}/)
      end
    end

    context 'with header Authorization is token nil' do
      before do
        delete user_url(user), headers: { Authorization: nil }
      end

      it 'response status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('token.not_provided')}/)
      end
    end

    context 'with user authenticate and expired token' do
      before do
        sleep(7.seconds)
        delete user_url(user), headers: { Authorization: "Bearer #{token}" }
      end

      it 'response status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors].first).to match(/#{I18n.t('token.expired')}/)
      end
    end
  end

  describe 'POST /create_token' do
    let!(:user) { create(:user) }

    context 'with valid parameters' do
      before do
        post create_token_url, params: { email: user.email, password: 'password' }
      end

      it 'responses status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with valid parameters and user not authenticate' do
      before do
        post create_token_url, params: { email: user.email, password: user.password_digest }
      end

      it 'responses status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('create_token.email_or_password_not_match')}/)
      end
    end

    context 'with parameters email is nil' do
      before do
        post create_token_url, params: { email: nil, password: user.password_digest }
      end

      it 'responses status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('create_token.email_not_present')}/)
      end
    end

    context 'with parameters password is nil' do
      before do
        post create_token_url, params: { email: user.email, password: nil }
      end

      it 'responses status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('create_token.password_not_present')}/)
      end
    end
  end
end
