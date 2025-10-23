# Ryde

A Strava-ish app to track bicycle rides

## Features

- OAuth authentication (Google, Apple) and traditional email/password
- Auto-read from Wahoo devices
- Map rides
- Track best efforts
- Track heart rate and heart rate zones
- Track goals
- Track bikes and components

## Documentation

- [Authentication](docs/AUTHENTICATION.md) - Comprehensive guide to the authentication system

## Getting Started

You can run Ryde in two ways:
1. **Using VS Code Devcontainer** (recommended) - Includes PostgreSQL, all dependencies pre-configured
2. **Local development** - Uses SQLite, requires manual setup

### Option 1: VS Code Devcontainer (Recommended)

#### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [VS Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

#### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ryde.git
   cd ryde
   ```

2. Open in VS Code:
   ```bash
   code .
   ```

3. When prompted, click **"Reopen in Container"**
   - Or press `F1` → "Dev Containers: Reopen in Container"
   - First build takes 5-10 minutes

4. Wait for automatic setup:
   - Container builds with Ruby, PostgreSQL, Node.js
   - `bundle install` runs automatically
   - Database is created and migrated
   - Ready to code!

5. Start the server:
   ```bash
   bin/rails server
   ```

6. Open http://localhost:3000

#### Devcontainer Features
- ✅ PostgreSQL 16 database
- ✅ Ruby 3.4 with all gems
- ✅ Node.js LTS
- ✅ Git & GitHub CLI
- ✅ Ruby LSP for intelligent code completion
- ✅ Automatic database setup

See [.devcontainer/README.md](.devcontainer/README.md) for troubleshooting and advanced usage.

### Option 2: Local Development

#### Prerequisites
- Ruby 3.4.7 or higher
- Rails 8.1.0 or higher
- SQLite3
- Node.js LTS

#### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ryde.git
   cd ryde
   ```

2. Install Ruby dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   bin/rails db:setup
   ```

4. Start the server:
   ```bash
   bin/rails server
   ```

5. Open http://localhost:3000

#### Running Tests
```bash
bin/rails test
```

#### Database Management
```bash
# Reset database
bin/rails db:reset

# Run migrations
bin/rails db:migrate

# Rollback migration
bin/rails db:rollback
```

### OAuth Configuration

To enable Google and Apple sign-in, configure OAuth credentials:

```bash
# Edit encrypted credentials
bin/rails credentials:edit
```

Add your OAuth credentials:
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

For detailed OAuth setup instructions, see [Authentication Documentation](docs/AUTHENTICATION.md).

## Development

This project follows strict code quality guidelines. See [claude.md](claude.md) for:
- Git workflow (always use feature branches)
- Sandi Metz' rules
- Clean code principles
- Rails best practices
- Testing requirements

