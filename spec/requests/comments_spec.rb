require 'rails_helper'

RSpec.describe '/comments', type: :request do
  let!(:comment) { create(:comment) }

  describe 'GET /index' do
    context 'with user not authenticated' do
      before do
        get comments_url
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    context 'with user not authenticated' do
      before do
        get comment_url(comment)
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end

    context 'with user not authenticated and params id is null' do
      before do
        get comment_url('null')
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
    context 'with user not authenticated and valid parameters' do
      before do
        post comments_url, params: { comment: attributes_for(:comment) }
      end

      it 'response status ok' do
        expect(response).to be_successful
      end

      it 'renders a JSON response with the patch' do
        expect(response.content_type).to match('application/json')
      end
    end

    context 'with user not authenticated and invalid parameters' do
      before do
        post comments_url, params: { comment: { name: nil } }
      end

      it 'response status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders a JSON response with the patch' do
        expect(response.content_type).to match('application/json')
      end
    end
  end

  describe 'PATCH /update' do
    context 'with user not authenticated and valid parameters' do
      before do
        patch comment_url(comment), params: { comment: { name: 'New Name' } }
      end

      it 'response status ok' do
        expect(response).to be_successful
      end

      it 'renders a JSON response with the patch' do
        expect(response.content_type).to match('application/json')
      end
    end

    context 'with user not authenticated and invalid parameters' do
      before do
        patch comment_url(comment), params: { comment: { name: nil } }
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
    context 'with user not authenticated' do
      before do
        delete comment_url(comment)
      end

      it 'response status ok' do
        expect(response).to be_successful
      end
    end
  end
end
