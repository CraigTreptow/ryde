require "test_helper"

class OauthAuthenticatorTest < ActiveSupport::TestCase
  def setup
    @auth_hash = {
      "provider" => "google_oauth2",
      "uid" => "new_oauth_123456",
      "info" => { "email" => "newuser@example.com" }
    }
  end

  test "creates new user and service for new OAuth user" do
    authenticator = OauthAuthenticator.new(@auth_hash)

    assert_difference [ "User.count", "ConnectedService.count" ], 1 do
      result = authenticator.authenticate
      assert result.success?
      assert_equal "newuser@example.com", result.user.email_address
    end
  end

  test "finds existing service and returns user" do
    user = User.create!(email_address: "existing@example.com")
    user.connected_services.create!(
      provider: "google_oauth2",
      uid: "existing_123"
    )

    auth_hash = {
      "provider" => "google_oauth2",
      "uid" => "existing_123",
      "info" => { "email" => "existing@example.com" }
    }

    authenticator = OauthAuthenticator.new(auth_hash)

    assert_no_difference [ "User.count", "ConnectedService.count" ] do
      result = authenticator.authenticate
      assert result.success?
      assert_equal user.id, result.user.id
    end
  end

  test "adds service to existing user with same email" do
    user = User.create!(email_address: "adding@example.com")

    auth_hash = {
      "provider" => "google_oauth2",
      "uid" => "adding_123",
      "info" => { "email" => "adding@example.com" }
    }

    authenticator = OauthAuthenticator.new(auth_hash)

    assert_difference "ConnectedService.count", 1 do
      assert_no_difference "User.count" do
        result = authenticator.authenticate
        assert result.success?
        assert_equal user.id, result.user.id
      end
    end
  end

  test "fails when email belongs to different user" do
    User.create!(
      email_address: "password_user@example.com",
      password: "password123"
    )

    different_auth = {
      "provider" => "apple",
      "uid" => "different_999",
      "info" => { "email" => "password_user@example.com" }
    }

    authenticator = OauthAuthenticator.new(different_auth)

    assert_no_difference [ "User.count", "ConnectedService.count" ] do
      result = authenticator.authenticate
      assert_not result.success?
      assert_not_nil result.error_message
    end
  end
end
