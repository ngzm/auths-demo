require 'test_helper'

class Rp::GoogleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rp_google_index_url
    assert_response :success
  end

  test "should get create" do
    get rp_google_create_url
    assert_response :success
  end

  test "should get show" do
    get rp_google_show_url
    assert_response :success
  end

end
