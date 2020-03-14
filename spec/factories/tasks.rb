FactoryBot.define do
  factory :task do
    name { '筋トレ' }
    activity_at { '2020-01-01 00:00:00' }
    sequence(:weight) { |n| n }
    sequence(:lep) { |n| n }
    sequence(:set) { |n| n }
    description { 'メモ' }
    user
  end
end
