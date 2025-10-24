require "test_helper"

class OauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
  end

  teardown do
    OmniAuth.config.test_mode = false
  end

  test "successful Google OAuth authentication creates user and session" do
    OmniAuth.config.mock_auth[:google_oauth2] = {
      "provider" => "google_oauth2",
      "uid" => "new_google_user_999",
      "info" => { "email" => "oauth_test@example.com" }
    }

    assert_difference "User.count", 1 do
      assert_difference "ConnectedService.count", 1 do
        post "/auth/google_oauth2/callback"
      end
    end

    assert_redirected_to root_path
    assert_equal "Signed in successfully!", flash[:notice]
    assert cookies[:session_id].present?
  end

  test "successful Apple OAuth authentication creates user and session" do
    OmniAuth.config.mock_auth[:apple] = {
      "provider" => "apple",
      "uid" => "apple_123456",
      "info" => { "email" => "apple_test@example.com" }
    }

    assert_difference "User.count", 1 do
      assert_difference "ConnectedService.count", 1 do
        post "/auth/apple/callback"
      end
    end

    assert_redirected_to root_path
    assert_equal "Signed in successfully!", flash[:notice]
    assert cookies[:session_id].present?
  end

  test "existing OAuth user can sign in again" do
    user = User.create!(email_address: "existing_oauth@example.com")
    user.connected_services.create!(
      provider: "google_oauth2",
      uid: "existing_123"
    )

    OmniAuth.config.mock_auth[:google_oauth2] = {
      "provider" => "google_oauth2",
      "uid" => "existing_123",
      "info" => { "email" => "existing_oauth@example.com" }
    }

    assert_no_difference [ "User.count", "ConnectedService.count" ] do
      post "/auth/google_oauth2/callback"
    end

    assert_redirected_to root_path
    assert_equal "Signed in successfully!", flash[:notice]
  end

  test "OAuth fails when email belongs to password user" do
    User.create!(
      email_address: "password_user@example.com",
      password: "password123"
    )

    OmniAuth.config.mock_auth[:google_oauth2] = {
      "provider" => "google_oauth2",
      "uid" => "new_123",
      "info" => { "email" => "password_user@example.com" }
    }

    assert_no_difference [ "User.count", "ConnectedService.count" ] do
      post "/auth/google_oauth2/callback"
    end

    assert_redirected_to new_session_path
    assert flash[:alert].present?
    assert_nil cookies[:session_id]
  end

  test "failed OAuth authentication" do
    get "/auth/failure"

    assert_redirected_to new_session_path
    assert_equal "Authentication failed.", flash[:alert]
  end
end
