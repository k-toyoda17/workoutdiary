FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'RSpec動作確認' }
    user
  end
end
