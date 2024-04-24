require 'rails_helper'

RSpec.describe '/posts', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { JWT.encode({ user_id: user.id, exp: 5.seconds.from_now.to_i }, Rails.application.secret_key_base) }

  let!(:valid_headers) { { Authorization: "Bearer #{token}" } }

  describe 'GET /index' do
    context 'with user not authenticated' do
      before do
        get posts_url
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    let!(:post) { create(:post) }

    context 'with user authenticated' do
      before do
        get post_url(post), headers: valid_headers
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end

    context 'with user authenticated and params id is null' do
      before do
        get post_url('null'), headers: valid_headers
      end

      it 'response status bad_request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'response message error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to match(/#{I18n.t('params.invalid')}/)
      end
    end

    context 'with header Authorization is token type error' do
      before do
        get post_url(post), headers: { Authorization: token }
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
        get post_url(post), headers: { Authorization: nil }
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
        get post_url(post), headers: { Authorization: "Bearer #{token}" }
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

  describe 'POST /create' do
    context 'with user authenticated and valid parameters' do
      before do
        post posts_url, headers: valid_headers, params: { post: attributes_for(:post) }
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end

    context 'with user authenticated and invalid parameters' do
      before do
        post posts_url, headers: valid_headers, params: { post: { title: nil } }
      end

      it 'response status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with header Authorization is token type error' do
      before do
        post posts_url, headers: { Authorization: token }, params: { post: attributes_for(:post) }
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
        post posts_url, headers: { Authorization: nil }, params: { post: attributes_for(:post) }
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
        post posts_url, headers: { Authorization: "Bearer #{token}" }, params: { post: attributes_for(:post) }
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
    let!(:post) { create(:post) }

    context 'with user authenticated and valid parameters' do
      before do
        patch post_url(post), headers: valid_headers, params: { post: { title: 'New Title' } }
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
        patch post_url(post), headers: valid_headers, params: { post: { title: nil } }
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
        patch post_url(post), headers: { Authorization: token }, params: { post: { title: 'New Title' } }
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
        patch post_url(post), headers: { Authorization: nil }, params: { post: { title: 'New Title' } }
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
        patch post_url(post), headers: { Authorization: "Bearer #{token}" }, params: { post: { title: 'New Title' } }
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
    let!(:post) { create(:post) }

    context 'with user authenticated' do
      before do
        delete post_url(post), headers: valid_headers
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end

    context 'with header Authorization is token type error' do
      before do
        delete post_url(post), headers: { Authorization: token }
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
        delete post_url(post), headers: { Authorization: nil }
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
        delete post_url(post), headers: { Authorization: "Bearer #{token}" }
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
end
