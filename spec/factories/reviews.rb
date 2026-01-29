FactoryBot.define do
  factory :review do
    content { "とても面白い本でした" }
    is_spoiler { false }
    public_id { Faker::Alphanumeric.alphanumeric(number: 12) }

    association :user
    association :book
    association :image_tag
  end
end
