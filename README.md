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

### Prerequisites

- Ruby 3.4.7+
- Rails 8.1.0+
- PostgreSQL (for production/Heroku)
- SQLite3 (for development)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/ryde.git
cd ryde

# Install dependencies
bundle install

# Set up database
bin/rails db:setup

# Run the server
bin/rails server
```

### Configuration

Configure OAuth providers by editing encrypted credentials:

```bash
bin/rails credentials:edit
```

See [Authentication Documentation](docs/AUTHENTICATION.md) for detailed setup instructions.

## Development

This project follows strict code quality guidelines. See [claude.md](claude.md) for:
- Git workflow (always use feature branches)
- Sandi Metz' rules
- Clean code principles
- Rails best practices
- Testing requirements

