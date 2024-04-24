FactoryBot.define do
  factory :comment do
    name { 'João' }
    text { 'Eu gostei muito do livro...' }
    post_id { FactoryBot.create(:post).id }
  end
end
