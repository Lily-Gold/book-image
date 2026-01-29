require 'rails_helper'

RSpec.describe Book, type: :model do
  describe "validations" do
    it "有効なファクトリを持つこと" do
      book = build(:book)
      expect(book).to be_valid
    end

    it "titleがなければ無効であること" do
      book = build(:book, title: nil)
      expect(book).to be_invalid
    end

    it "titleが121文字以上だと無効であること" do
      book = build(:book, title: "a" * 121)
      expect(book).to be_invalid
    end

    it "authorが100文字以内なら有効であること" do
      book = build(:book, author: "a" * 100)
      expect(book).to be_valid
    end

    it "publisherが100文字以内なら有効であること" do
      book = build(:book, publisher: "a" * 100)
      expect(book).to be_valid
    end

    it "isbnが20文字以内なら有効であること" do
      book = build(:book, isbn: "a" * 20)
      expect(book).to be_valid
    end

    it "google_books_idが80文字以内なら有効であること" do
      book = build(:book, google_books_id: "a" * 80)
      expect(book).to be_valid
    end
  end

  describe "associations" do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should belong_to(:user).optional }
  end
end
