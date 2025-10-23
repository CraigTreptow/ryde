require "test_helper"

class OauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  test "successful Google OAuth authentication" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = {
      "provider" => "google_oauth2",
      "uid" => "123456",
      "info" => { "email" => "oauth_test@example.com" }
    }

    post "/auth/google_oauth2/callback"

    assert_redirected_to root_path
    assert_equal "Signed in successfully!", flash[:notice]
  end

  test "failed OAuth authentication" do
    get "/auth/failure"

    assert_redirected_to new_session_path
    assert_equal "Authentication failed.", flash[:alert]
  end
end
