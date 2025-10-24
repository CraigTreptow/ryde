# Ryde

A Strava-ish app to track bicycle rides

## Features

- Email/password authentication
- Auto-read from Wahoo devices
- Map rides
- Track best efforts
- Track heart rate and heart rate zones
- Track goals
- Track bikes and components

## Getting Started

### Prerequisites
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

5. Open http://localhost:3000 and create an account

### Authentication

The app uses email/password authentication powered by Rails 8's built-in authentication system.

**To get started:**
1. Visit http://localhost:3000
2. Click "Don't have an account? Sign up"
3. Create your account with email and password
4. You'll be automatically signed in

#### Running Tests
```bash
# Run all tests (excluding system tests)
bin/rails test

# Run system tests (requires Chrome)
bin/rails test:system

# Run all CI checks (security scans, linting, tests)
bin/ci
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

## Frontend & Styling

### Bootstrap 5 Integration
Ryde uses Bootstrap 5.3.8 integrated via importmap for modern, responsive UI components.

**JavaScript**: Bootstrap and Popper.js are loaded via importmap:
```ruby
# config/importmap.rb
pin "bootstrap" # @5.3.8
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
```

**CSS**: Loaded alphabetically via Propshaft from `app/assets/stylesheets/`:
1. `application.css` - Global styles and utilities
2. `bootstrap.min.css` - Bootstrap 5 framework
3. `ryde-theme.css` - Custom Ryde theme overrides

### Custom Ryde Theme
The app features a distinctive dark green theme with neon accent colors:

- **Background**: Dark green gradient (#003300 → #001a00)
- **Accent Color**: Neon green (#66ff99) for branding
- **Typography**: Monospace fonts for headings/branding, sans-serif for body
- **Components**: Custom-styled navbar, cards, buttons, and forms with backdrop blur effects

Theme customization is done via CSS variables in `app/assets/stylesheets/ryde-theme.css`.

### Brand Assets
- **Logo**: `app/assets/images/logo.svg` (360x80 wordmark with cycling wheel)
- **Favicon**: `public/icon.svg` and `public/icon.png` (cycling wheel icon)

## Development

This project follows strict code quality guidelines. See [claude.md](claude.md) for:
- Git workflow (always use feature branches)
- Sandi Metz' rules
- Clean code principles
- Rails best practices
- Testing requirements

