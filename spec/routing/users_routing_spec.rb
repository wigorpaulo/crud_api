require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users').to route_to('users#index')
    end

    it 'routes to #create_token' do
      expect(post: '/create_token').to route_to('users#create_token')
    end
  end
end
