require "test_helper"

class ReservationModelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get reservation_models_index_url
    assert_response :success
  end

  test "should get show" do
    get reservation_models_show_url
    assert_response :success
  end

  test "should get new" do
    get reservation_models_new_url
    assert_response :success
  end

  test "should get create" do
    get reservation_models_create_url
    assert_response :success
  end

  test "should get edit" do
    get reservation_models_edit_url
    assert_response :success
  end

  test "should get update" do
    get reservation_models_update_url
    assert_response :success
  end

  test "should get destroy" do
    get reservation_models_destroy_url
    assert_response :success
  end
end
