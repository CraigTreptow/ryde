class OauthCallbacksController < ApplicationController
  allow_unauthenticated_access

  def create
    result = authenticate_with_oauth

    handle_result(result)
  end

  def failure
    redirect_to new_session_path,
      alert: "Authentication failed."
  end

  private

  def authenticate_with_oauth
    authenticator = OauthAuthenticator.new(auth_hash)
    authenticator.authenticate
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

  def handle_result(result)
    result.success? ? handle_success(result) : handle_failure(result)
  end

  def handle_success(result)
    start_new_session_for(result.user)
    redirect_to after_authentication_url,
      notice: "Signed in successfully!"
  end

  def handle_failure(result)
    redirect_to new_session_path,
      alert: result.error_message
  end
end
