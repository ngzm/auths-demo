require 'test_helper'

class Rp::TwitterControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get rp_twitter_create_url
    assert_response :success
  end

  test "should get show" do
    get rp_twitter_show_url
    assert_response :success
  end

end
