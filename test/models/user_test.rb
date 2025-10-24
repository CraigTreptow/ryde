require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "requires password for new users" do
    user = User.new(email_address: "test@example.com")
    assert_not user.valid?
    assert user.errors[:password].any?
  end

  test "requires email_address" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert user.errors[:email_address].any?
  end

  test "requires unique email_address" do
    User.create!(email_address: "unique@example.com", password: "password123")
    duplicate_user = User.new(email_address: "unique@example.com", password: "password456")
    assert_not duplicate_user.valid?
    assert duplicate_user.errors[:email_address].any?
  end
end
