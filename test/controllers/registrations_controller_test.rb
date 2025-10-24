require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path
    assert_response :success
  end

  test "registration page contains sign-up form" do
    get new_registration_path

    assert_select "form[action='#{registration_path}']"
    assert_select "input[type='email'][name='user[email_address]']"
    assert_select "input[type='password'][name='user[password]']"
    assert_select "input[type='password'][name='user[password_confirmation]']"
    assert_select "input[type='submit'][value='Create Account']"
  end

  test "create with valid data creates user and signs in" do
    assert_difference "User.count", 1 do
      post registration_path, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid data shows errors" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "different"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".alert-danger"
  end

  test "create with missing email shows errors" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email_address: "",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "create with duplicate email shows errors" do
    User.create!(email_address: "existing@example.com", password: "password123")

    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email_address: "existing@example.com",
          password: "password456",
          password_confirmation: "password456"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".alert-danger"
  end
end
