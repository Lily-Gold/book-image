require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    sign_in users(:one)
    get profile_url
    assert_response :success
  end
end
