require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "validations" do
    it "有効なファクトリを持つこと" do
      review = create(:review)
      expect(review).to be_valid
    end

    it "contentがなければ無効であること" do
      review = build(:review, content: nil)
      expect(review).to be_invalid
    end

    it "contentが5001文字以上だと無効であること" do
      review = build(:review, content: "a" * 5001)
      expect(review).to be_invalid
    end

    it "image_tagがなければ無効であること" do
      review = build(:review, image_tag: nil)
      expect(review).to be_invalid
    end

    it "is_spoilerがtrue/false以外だと無効であること" do
      review = build(:review, is_spoiler: nil)
      expect(review).to be_invalid
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:book).optional }
    it { should belong_to(:image_tag) }

    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "callbacks" do
    it "作成時にpublic_idが自動で設定されること" do
      review = create(:review, public_id: nil)
      expect(review.public_id).to be_present
    end
  end

  describe ".same_book" do
    it "同じgoogle_books_idの本を持つレビューを取得すること" do
      book = create(:book, google_books_id: "abc")

      review1 = create(:review, book: book)
      review2 = create(:review, book: book)

      expect(Review.same_book(review1)).to include(review2)
      expect(Review.same_book(review1)).not_to include(review1)
    end
  end
end
