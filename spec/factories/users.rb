FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'user1' }
    email { 'user1@mail.com' }
    password { 'password' }
  end
end
