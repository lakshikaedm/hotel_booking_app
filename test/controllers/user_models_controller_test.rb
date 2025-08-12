require "test_helper"

class UserModelsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_models_new_url
    assert_response :success
  end

  test "should get create" do
    get user_models_create_url
    assert_response :success
  end

  test "should get show" do
    get user_models_show_url
    assert_response :success
  end

  test "should get edit" do
    get user_models_edit_url
    assert_response :success
  end

  test "should get update" do
    get user_models_update_url
    assert_response :success
  end
end
