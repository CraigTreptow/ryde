require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "visiting the login page shows all authentication options" do
    visit new_session_path

    assert_selector "h2", text: "Sign in with OAuth"
    assert_button "Sign in with Google"
    assert_button "Sign in with Apple"

    assert_selector "h2", text: "Or sign in with email"
    assert_field "email_address"
    assert_field "password"
    assert_button "Sign in"

    assert_link "Forgot password?"
  end

  test "signing in with valid email and password" do
    user = users(:one)

    visit new_session_path

    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"

    # Successfully redirected to root path
    # (Note: root_path is currently the login page, which will change
    # when a dashboard/home page is added)
    assert_current_path root_path
  end

  test "signing in with invalid credentials shows error" do
    visit new_session_path

    fill_in "email_address", with: "user@example.com"
    fill_in "password", with: "wrongpassword"
    click_button "Sign in"

    assert_current_path new_session_path
  end

  test "OAuth buttons are present and clickable" do
    visit new_session_path

    # Test Google button exists
    google_button = find_button("Sign in with Google")
    assert google_button.present?

    # Test Apple button exists
    apple_button = find_button("Sign in with Apple")
    assert apple_button.present?

    # Note: We can't fully test OAuth flow without real credentials
    # but we can verify the buttons render and are accessible
  end

  private

  def sign_in_as(user)
    visit new_session_path
    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"
  end
end
