require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { FactoryBot.create(:post) }

  context 'with should attributes response' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:text) }
    it { is_expected.to respond_to(:user_id) }
  end

  context 'with should relations' do
    it { is_expected.to belong_to(:user) }
  end
end
