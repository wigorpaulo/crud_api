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
    context 'with user authenticated' do
      let!(:post) { create(:post) }

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
  end

  describe 'PATCH /update' do
    context 'with user authenticated and valid parameters' do
      let!(:post) { create(:post) }

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
      let!(:post) { create(:post) }

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
  end

  describe 'DELETE /destroy' do
    context 'with user authenticated' do
      let!(:post) { create(:post) }

      before do
        delete post_url(post), headers: valid_headers
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end

    # it 'destroys the requested post' do
    #   post = Post.create! valid_attributes
    #   expect {
    #     delete post_url(post), headers: valid_headers, as: :json
    #   }.to change(Post, :count).by(-1)
    # end
  end
end
