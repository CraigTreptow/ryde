require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "visiting the login page shows authentication options" do
    visit new_session_path

    assert_selector "h2", text: "Sign In"
    assert_field "email_address"
    assert_field "password"
    assert_button "Sign in"

    assert_link "Forgot password?"
    assert_link "Don't have an account? Sign up"
  end

  test "signing in with valid email and password" do
    user = users(:one)

    visit new_session_path

    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"

    # Successfully redirected to home page
    assert_current_path root_path
    assert_selector "h1", text: "Welcome to Ryde!"
  end

  test "signing in with invalid credentials shows error" do
    visit new_session_path

    fill_in "email_address", with: "user@example.com"
    fill_in "password", with: "wrongpassword"
    click_button "Sign in"

    assert_current_path new_session_path
  end

  test "registration link navigates to sign up page" do
    visit new_session_path

    click_link "Don't have an account? Sign up"

    assert_current_path new_registration_path
    assert_selector "h2", text: "Create Account"
  end

  test "creating a new account and signing in" do
    visit new_registration_path

    fill_in "Email address", with: "newuser@example.com"
    fill_in "Password", with: "securepassword123"
    fill_in "Confirm Password", with: "securepassword123"
    click_button "Create Account"

    # Successfully signed in and redirected to home page
    assert_current_path root_path
    assert_selector "h1", text: "Welcome to Ryde!"
    assert_text "newuser@example.com"
  end

  private

  def sign_in_as(user)
    visit new_session_path
    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"
  end
end
