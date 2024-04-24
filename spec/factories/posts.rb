FactoryBot.define do
  factory :post do
    id { 1 }
    title { 'MyString' }
    text { 'MyText' }
    user_id { FactoryBot.create(:user).id }
  end
end
