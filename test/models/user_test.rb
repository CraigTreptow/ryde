require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "allows OAuth users without password" do
    user = User.create!(email_address: "oauth_user@example.com")
    user.connected_services.create!(
      provider: "google_oauth2",
      uid: "oauth_123"
    )

    assert user.valid?
  end

  test "has many connected services" do
    user = User.create!(email_address: "services_user@example.com")

    assert_respond_to user, :connected_services
  end

  test "destroys connected services when destroyed" do
    user = User.create!(email_address: "destroy_test@example.com")
    user.connected_services.create!(
      provider: "google_oauth2",
      uid: "destroy_123"
    )

    assert_difference "ConnectedService.count", -1 do
      user.destroy
    end
  end
end
