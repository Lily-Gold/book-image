class BooksController < ApplicationController
  def index
    @books = Book.order(created_at: :desc)
  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews.includes(:user, :image_tag)
  end
end
