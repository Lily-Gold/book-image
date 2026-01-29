FactoryBot.define do
  factory :image_tag do
    sequence(:name) { |n| "テストカラー#{n}" }
    sequence(:color) { |n| "#FF00#{format('%02d', n)}" }
  end
end
