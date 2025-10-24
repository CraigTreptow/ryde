require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_session_path
    assert_response :success
  end

  test "login page contains OAuth buttons" do
    get new_session_path

    assert_select "form[action='/auth/google_oauth2']", 1
    assert_select "form[action='/auth/apple']", 1
    assert_select "button", text: "Sign in with Google"
    assert_select "button", text: "Sign in with Apple"
  end

  test "login page contains email/password form" do
    get new_session_path

    assert_select "form[action='#{session_path}']"
    assert_select "input[type='email'][name='email_address']"
    assert_select "input[type='password'][name='password']"
    assert_select "input[type='submit'][value='Sign in']"
  end

  test "create with valid credentials" do
    post session_path, params: {email_address: @user.email_address, password: "password"}

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post session_path, params: {email_address: @user.email_address, password: "wrong"}

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(User.take)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end
end
