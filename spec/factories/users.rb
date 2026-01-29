FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "ユーザー#{n}" }
    introduction { "自己紹介です" }
    email { Faker::Internet.unique.email }
    password { "password123" }
  end
end
