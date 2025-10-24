class OauthResult
  attr_reader :user, :error_message

  def initialize(success, user, error_message)
    @success = success
    @user = user
    @error_message = error_message
  end

  def success?
    @success
  end
end
