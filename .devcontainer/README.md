# VS Code Devcontainer Setup

This devcontainer configuration provides a complete development environment for Ryde with PostgreSQL database support.

## Features

- Ruby 3.4
- PostgreSQL 16
- Node.js LTS
- Git and GitHub CLI
- VS Code extensions:
  - Ruby LSP (Shopify)
  - Tailwind CSS IntelliSense
  - Prettier

## Getting Started

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [VS Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Usage

1. Open the project in VS Code
2. Click "Reopen in Container" when prompted (or press F1 and select "Dev Containers: Reopen in Container")
3. Wait for the container to build and start
4. The database will be automatically set up via `postCreateCommand`

### Services

- **App**: Rails application (port 3000)
- **Database**: PostgreSQL (port 5432)
  - Host: `db`
  - Username: `postgres`
  - Password: `postgres`
  - Database: `ryde_development`

### Database Configuration

The app automatically uses PostgreSQL in the devcontainer via the `DATABASE_URL` environment variable.

If you need to reset the database:

```bash
bin/rails db:reset
```

### Running Tests

Tests run with SQLite for speed:

```bash
bin/rails test
```

### Manual Setup (if needed)

If the postCreateCommand fails, run manually:

```bash
bundle install
bin/rails db:prepare
```

## Troubleshooting

### Container won't start

1. Ensure Docker Desktop is running
2. Check Docker has enough resources (4GB RAM minimum recommended)
3. Try rebuilding: F1 → "Dev Containers: Rebuild Container"

### Database connection fails

Check that the `db` service is running:

```bash
docker-compose ps
```

### Ports already in use

If ports 3000 or 5432 are in use, stop other services or modify the ports in `docker-compose.yml`.

## Local Development (without devcontainer)

If you prefer to work locally without Docker, the app will automatically fall back to SQLite. Just ensure you have:

- Ruby 3.4.7+
- SQLite3
- Node.js LTS

Then run:

```bash
bundle install
bin/rails db:setup
bin/rails server
```
