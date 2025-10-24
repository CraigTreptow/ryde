require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "redirects to sign in when not authenticated" do
    get root_path
    assert_redirected_to new_session_path
  end

  test "shows home page when authenticated" do
    sign_in_as(User.take)
    get root_path
    assert_response :success
    assert_select "h1", text: "Welcome to Ryde!"
  end

  test "home page shows user email" do
    user = User.take
    sign_in_as(user)
    get root_path
    assert_select "span", text: user.email_address
  end

  test "home page has sign out button" do
    sign_in_as(User.take)
    get root_path
    assert_select "form[action='#{session_path}'][method='post']"
  end
end
