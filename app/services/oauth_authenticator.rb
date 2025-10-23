class OauthAuthenticator
  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def authenticate
    service = find_or_create_service
    service ? success(service.user) : failure
  end

  private

  attr_reader :auth_hash

  def find_or_create_service
    find_service || create_service
  end

  def find_service
    ConnectedService.find_by(
      provider: provider,
      uid: uid
    )
  end

  def create_service
    return nil if password_account_exists?

    user = find_or_create_user
    user.connected_services.create!(
      provider: provider,
      uid: uid
    )
  end

  def find_or_create_user
    User.find_or_create_by!(email_address: email)
  end

  def password_account_exists?
    existing_user = User.find_by(email_address: email)
    existing_user&.password_digest.present?
  end

  def provider
    auth_hash["provider"]
  end

  def uid
    auth_hash["uid"]
  end

  def email
    auth_hash.dig("info", "email")
  end

  def success(user)
    OauthResult.new(true, user, nil)
  end

  def failure
    message = "Could not authenticate."
    OauthResult.new(false, nil, message)
  end
end
