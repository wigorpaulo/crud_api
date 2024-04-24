require 'rails_helper'

RSpec.describe '/posts', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:token) { JWT.encode({ user_id: user.id, exp: 5.seconds.from_now.to_i }, Rails.application.secret_key_base) }

  let(:valid_headers) { { Authorization: "Bearer #{token}" } }

  describe 'GET /index' do
    context 'with user authenticated' do
      before do
        get posts_url, headers: valid_headers
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end

    context 'with header Authorization is token type error' do
      before do
        get posts_url, headers: { Authorization: token }
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
        get posts_url, headers: { Authorization: nil }
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
        get posts_url, headers: valid_headers
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

  describe 'GET /show' do
    it 'renders a successful response' do
      post = Post.create! valid_attributes
      get post_url(post), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Post' do
        expect {
          post posts_url,
               params: { post: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Post, :count).by(1)
      end

      it 'renders a JSON response with the new post' do
        post posts_url,
             params: { post: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Post' do
        expect {
          post posts_url,
               params: { post: invalid_attributes }, as: :json
        }.to change(Post, :count).by(0)
      end

      it 'renders a JSON response with errors for the new post' do
        post posts_url,
             params: { post: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      it 'updates the requested post' do
        post = Post.create! valid_attributes
        patch post_url(post),
              params: { post: new_attributes }, headers: valid_headers, as: :json
        post.reload
        skip('Add assertions for updated state')
      end

      it 'renders a JSON response with the post' do
        post = Post.create! valid_attributes
        patch post_url(post),
              params: { post: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the post' do
        post = Post.create! valid_attributes
        patch post_url(post),
              params: { post: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested post' do
      post = Post.create! valid_attributes
      expect {
        delete post_url(post), headers: valid_headers, as: :json
      }.to change(Post, :count).by(-1)
    end
  end
end
