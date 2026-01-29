require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "有効なファクトリを持つこと" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "nameがなければ無効であること" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
    end

    it "nameが16文字以上だと無効であること" do
      user = build(:user, name: "a" * 16)
      expect(user).to be_invalid
    end

    it "introductionが201文字以上だと無効であること" do
      user = build(:user, introduction: "a" * 201)
      expect(user).to be_invalid
    end

    it "providerとuidの両方がある場合は有効であること" do
      user = build(:user, provider: "google_oauth2", uid: "12345")
      expect(user).to be_valid
    end
  end

  describe "associations" do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:books).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:notifications).dependent(:destroy) }

    it do
      should have_many(:active_notifications)
        .class_name("Notification")
        .with_foreign_key("actor_id")
        .dependent(:destroy)
    end
  end

  describe "callbacks" do
    it "introductionが未設定の場合、デフォルト値が入ること" do
      user = create(:user, introduction: nil)
      expect(user.introduction).to eq "よろしくお願いします。"
    end
  end
end
