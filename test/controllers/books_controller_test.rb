require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get books_url
    assert_response :success
  end

  test "should get show" do
    book = books(:one)
    get book_url(book)
    assert_response :success
  end
end
