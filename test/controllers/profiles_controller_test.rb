require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = UserModel.create!(
      name: "Taro",
      email: "taro@example.com",
      password: "password",
      bio: "hello"
    )
  end

  def log_in_as(user, password: "password")
    post session_path, params: { email: user.email, password: password }
  end

  test "edit requires login" do
    get edit_profile_path
    assert_redirected_to new_session_path
  end

  test "edit shows form when logged in" do
    log_in_as(@user)
    get edit_profile_path
    assert_response :success
    assert_select "h1", /プロフィール編集|プロフィール|編集/i
  end

  test "successful update redirects and changes attributes" do
    log_in_as(@user)
    patch profile_path, params: {
      user_model: {
        name: "New Name",
        bio:  "Updated bio"
      }
    }
    assert_redirected_to user_model_path(@user)
    @user.reload
    assert_equal "New Name", @user.name
    assert_equal "Updated bio", @user.bio
  end

  test "invalid update re-renders edit with 422" do
    log_in_as(@user)
    patch profile_path, params: {
      user_model: {
        name: ""
      }
    }
    assert_response :unprocessable_entity
    assert_select ".alert-danger", /エラー|error|invalid/i
  end
end
