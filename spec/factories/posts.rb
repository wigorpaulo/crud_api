FactoryBot.define do
  factory :post do
    title { 'MyString' }
    text { 'MyText' }
    user_id { FactoryBot.create(:user).id }
  end
end
