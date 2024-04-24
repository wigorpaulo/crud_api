require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }

  context 'with should attributes response' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:text) }
    it { is_expected.to respond_to(:post_id) }
  end

  context 'with should relations' do
    it { is_expected.to belong_to(:post) }
  end
end
