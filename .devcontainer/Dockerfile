FROM mcr.microsoft.com/devcontainers/ruby:3.4

# Install Rails dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    postgresql-client \
    libpq-dev \
    nodejs \
    npm \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Install bundler
RUN gem install bundler

# Create vscode user
RUN useradd -m -s /bin/bash vscode || true
USER vscode
