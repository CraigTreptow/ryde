# Authentication Documentation

Ryde uses a dual authentication system that supports both traditional email/password authentication and OAuth social login (Google and Apple).

## Table of Contents

- [Overview](#overview)
- [Authentication Methods](#authentication-methods)
- [Architecture](#architecture)
- [User Account Types](#user-account-types)
- [Security Considerations](#security-considerations)
- [Setup and Configuration](#setup-and-configuration)
- [Usage Examples](#usage-examples)
- [Testing](#testing)

## Overview

The authentication system is built on:
- **Rails 8 Authentication Generator** - Provides base email/password authentication
- **OmniAuth** - Handles OAuth flows for social login
- **Separate ConnectedService Model** - Securely links OAuth providers to user accounts

## Authentication Methods

### 1. Email/Password Authentication

Traditional username/password authentication using Rails 8's built-in authentication generator.

**Features:**
- Secure password hashing with bcrypt
- Password reset via email
- Session management with httponly cookies
- Rate limiting on login attempts

**Routes:**
- `GET /session/new` - Sign in page
- `POST /session` - Create session (sign in)
- `DELETE /session` - Destroy session (sign out)
- `GET /passwords/new` - Password reset request
- `GET /passwords/:token/edit` - Password reset form
- `PATCH /passwords/:token` - Update password

### 2. OAuth Social Login

OAuth 2.0 authentication supporting Google and Apple.

**Providers:**
- Google OAuth 2.0
- Apple Sign In

**Routes:**
- `POST /auth/:provider/callback` - OAuth callback handler
- `GET /auth/failure` - OAuth failure handler

**Flow:**
1. User clicks "Sign in with Google/Apple"
2. Redirected to provider's authentication page
3. User authorizes the application
4. Provider redirects back to `/auth/:provider/callback`
5. Application creates or finds user account
6. Session is created and user is signed in

## Architecture

### Models

#### User (`app/models/user.rb`)
The core user model with flexible password requirements.

```ruby
class User < ApplicationRecord
  has_secure_password validations: false
  has_many :sessions, dependent: :destroy
  has_many :connected_services, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true
end
```

**Key features:**
- `has_secure_password validations: false` - Allows OAuth users without passwords
- `password_digest` can be NULL for OAuth-only accounts
- Email normalization (lowercase, trimmed)

#### Session (`app/models/session.rb`)
Tracks user login sessions with device information.

**Fields:**
- `user_id` - Foreign key to users
- `ip_address` - IP address of login
- `user_agent` - Browser/device information
- `token` - Secure session token

#### ConnectedService (`app/models/connected_service.rb`)
Links OAuth providers to user accounts.

```ruby
class ConnectedService < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }
end
```

**Fields:**
- `user_id` - Foreign key to users
- `provider` - OAuth provider name (e.g., "google_oauth2", "apple")
- `uid` - Unique identifier from provider

**Database constraints:**
- Unique index on `[provider, uid]` - Prevents duplicate OAuth connections
- Foreign key to users with cascade delete

### Controllers

#### SessionsController (`app/controllers/sessions_controller.rb`)
Handles traditional email/password authentication.

**Actions:**
- `new` - Display sign in form
- `create` - Authenticate and create session
- `destroy` - Sign out user

#### OauthCallbacksController (`app/controllers/oauth_callbacks_controller.rb`)
Handles OAuth authentication callbacks.

**Actions:**
- `create` - Process OAuth callback and authenticate user
- `failure` - Handle OAuth failures

**Key principles:**
- Follows Sandi Metz rules (methods ≤ 5 lines)
- Single responsibility per method
- Delegates business logic to service objects

### Service Objects

#### OauthAuthenticator (`app/services/oauth_authenticator.rb`)
Encapsulates OAuth authentication business logic.

**Responsibilities:**
- Find existing OAuth connection
- Create new users from OAuth data
- Link OAuth providers to existing accounts
- Prevent account hijacking

**Methods:**
- `authenticate` - Main entry point, returns OauthResult
- `find_or_create_service` - Find or create ConnectedService
- `find_or_create_user` - Find or create User

**Security:**
- Prevents linking OAuth to different user's email
- Allows multiple OAuth providers per user
- Validates email matches before linking

#### OauthResult (`app/services/oauth_result.rb`)
Value object for authentication results.

**Attributes:**
- `success?` - Boolean indicating success/failure
- `user` - Authenticated user (if successful)
- `error_message` - Error description (if failed)

## User Account Types

### 1. Password-Only Users

Users who sign up with email and password only.

**Characteristics:**
- `password_digest` is present
- No connected services
- Sign in via `/session`

**Example:**
```ruby
user = User.create!(
  email_address: "user@example.com",
  password: "securepassword123"
)
```

### 2. OAuth-Only Users

Users who sign up exclusively through OAuth.

**Characteristics:**
- `password_digest` is NULL
- One or more connected services
- Sign in via OAuth providers only

**Example:**
```ruby
user = User.create!(email_address: "user@example.com")
user.connected_services.create!(
  provider: "google_oauth2",
  uid: "123456789"
)
```

### 3. Multi-OAuth Users

Users with multiple OAuth providers linked.

**Characteristics:**
- `password_digest` is NULL
- Multiple connected services
- Can sign in via any linked provider

**Example:**
```ruby
user = User.create!(email_address: "user@example.com")
user.connected_services.create!(provider: "google_oauth2", uid: "123456")
user.connected_services.create!(provider: "apple", uid: "789012")
```

## Security Considerations

### Account Hijacking Prevention

The system prevents account takeover attacks:

**Scenario:**
1. Alice creates account with password: `alice@example.com`
2. Bob tries to OAuth with Google using `alice@example.com`

**Protection:**
- `OauthAuthenticator#email_taken_by_other?` checks for existing email
- If email exists without matching provider, authentication fails
- Prevents Bob from accessing Alice's account

### Password Requirements

- Passwords use bcrypt for secure hashing
- `has_secure_password` provides built-in security
- Password not required for OAuth-only users
- Password field can be NULL in database

### Session Security

- Sessions use httponly cookies (XSS protection)
- SameSite: Lax (CSRF protection)
- Permanent signed cookies
- IP address and user agent tracking

### Rate Limiting

Password authentication includes rate limiting:
- 10 attempts per 3 minutes
- Prevents brute force attacks
- Implemented in `SessionsController`

### CSRF Protection

OAuth endpoints use POST-only callbacks:
- `omniauth-rails_csrf_protection` gem
- `OmniAuth.config.allowed_request_methods = [:post]`
- Prevents CSRF attacks on OAuth flows

## Setup and Configuration

### Environment Variables

OAuth credentials are stored in Rails encrypted credentials.

**Edit credentials:**
```bash
bin/rails credentials:edit
```

**Required structure:**
```yaml
google:
  client_id: YOUR_GOOGLE_CLIENT_ID
  client_secret: YOUR_GOOGLE_CLIENT_SECRET

apple:
  client_id: YOUR_APPLE_CLIENT_ID
  team_id: YOUR_APPLE_TEAM_ID
  key_id: YOUR_APPLE_KEY_ID
  private_key: |
    -----BEGIN PRIVATE KEY-----
    YOUR_APPLE_PRIVATE_KEY
    -----END PRIVATE KEY-----
```

### Google OAuth Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URI: `http://localhost:3000/auth/google_oauth2/callback`
6. Copy Client ID and Client Secret to credentials

### Apple Sign In Setup

1. Go to [Apple Developer Portal](https://developer.apple.com/)
2. Create an App ID with Sign In with Apple capability
3. Create a Service ID
4. Configure redirect URI: `http://localhost:3000/auth/apple/callback`
5. Create a private key for Sign In with Apple
6. Copy credentials to Rails credentials

### Database Migrations

The authentication system requires these migrations:

1. `CreateUsers` - User accounts
2. `CreateSessions` - Session tracking
3. `CreateConnectedServices` - OAuth provider links
4. `AllowNullPasswordDigestForOauthUsers` - Enable OAuth-only accounts

Run migrations:
```bash
bin/rails db:migrate
```

## Usage Examples

### Password Sign In

```ruby
# In view
<%= form_with url: session_path do |f| %>
  <%= f.email_field :email_address %>
  <%= f.password_field :password %>
  <%= f.submit "Sign In" %>
<% end %>
```

### OAuth Sign In

```ruby
# In view
<%= button_to "Sign in with Google",
    "/auth/google_oauth2",
    method: :post,
    data: { turbo: false } %>

<%= button_to "Sign in with Apple",
    "/auth/apple",
    method: :post,
    data: { turbo: false } %>
```

### Check Authentication Status

```ruby
# In controllers
if authenticated?
  # User is signed in
  current_user = Current.session.user
end
```

### Require Authentication

```ruby
# In controllers (inherited from ApplicationController)
class DashboardController < ApplicationController
  # Authentication required by default
end

# Allow unauthenticated access
class WelcomeController < ApplicationController
  allow_unauthenticated_access
end
```

## Testing

### Test Configuration

OAuth testing uses OmniAuth test mode:

```ruby
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:google_oauth2] = {
  "provider" => "google_oauth2",
  "uid" => "123456",
  "info" => { "email" => "test@example.com" }
}
```

### Test Coverage

- **Model tests** - Validations, associations, business logic
- **Controller tests** - Authentication flows, redirects
- **Service object tests** - OAuth authentication logic
- **Integration tests** - End-to-end authentication flows

### Running Tests

```bash
# All tests
bin/rails test

# Specific test files
bin/rails test test/models/user_test.rb
bin/rails test test/services/oauth_authenticator_test.rb
bin/rails test test/controllers/oauth_callbacks_controller_test.rb
```

## Troubleshooting

### OAuth Callback Not Working

Check that:
1. Redirect URIs match in provider settings
2. Credentials are correctly configured
3. OmniAuth initializer is loaded
4. Routes are correctly defined

### Password Authentication Fails

Check that:
1. User has `password_digest` set
2. Password is being sent in params
3. Email normalization is working
4. User account exists

### Account Linking Issues

If OAuth can't link to existing account:
- User with that email already exists
- Implement manual linking in account settings
- Or require different email for OAuth

## Future Enhancements

Potential improvements:

1. **Manual Account Linking** - Allow users to link OAuth in settings
2. **More OAuth Providers** - GitHub, Facebook, Twitter, etc.
3. **Two-Factor Authentication** - Additional security layer
4. **Email Verification** - Confirm email ownership
5. **Account Recovery** - Alternative recovery methods
6. **Session Management** - View/revoke active sessions
