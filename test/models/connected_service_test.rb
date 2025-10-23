require "test_helper"

class ConnectedServiceTest < ActiveSupport::TestCase
  test "valid connected service" do
    user = User.create!(email_address: "cs_valid@example.com")
    service = user.connected_services.build(
      provider: "google_oauth2",
      uid: "cs_valid_123"
    )

    assert service.valid?
  end

  test "requires provider" do
    service = ConnectedService.new(uid: "123")

    assert_not service.valid?
    assert_includes service.errors[:provider], "can't be blank"
  end

  test "requires uid" do
    service = ConnectedService.new(provider: "google")

    assert_not service.valid?
    assert_includes service.errors[:uid], "can't be blank"
  end

  test "requires unique uid per provider" do
    user = User.create!(email_address: "cs_unique@example.com")
    user.connected_services.create!(
      provider: "google_oauth2",
      uid: "unique_123"
    )

    duplicate = user.connected_services.build(
      provider: "google_oauth2",
      uid: "unique_123"
    )

    assert_not duplicate.valid?
  end

  test "allows same uid for different providers" do
    user = User.create!(email_address: "cs_multi@example.com")
    user.connected_services.create!(
      provider: "google_oauth2",
      uid: "multi_123"
    )

    apple_service = user.connected_services.build(
      provider: "apple",
      uid: "multi_123"
    )

    assert apple_service.valid?
  end
end
