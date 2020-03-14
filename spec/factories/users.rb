FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    password { 'password' }
    sequence(:email) { |n| "test#{n}@example.com" }
  end
end
