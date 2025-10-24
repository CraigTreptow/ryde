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

# Create vscode user if it doesn't exist
RUN useradd -m -s /bin/bash vscode 2>/dev/null || true

# Fix RVM permissions for vscode user
RUN if [ -d /usr/local/rvm ]; then \
        chgrp -R vscode /usr/local/rvm && \
        chmod -R g+w /usr/local/rvm; \
    fi

# Install bundler
RUN gem install bundler

# Switch to vscode user
USER vscode

# Configure bundler to install gems to user directory
RUN bundle config set --global path '/home/vscode/.bundle' && \
    bundle config set --global bin '/home/vscode/.bundle/bin'
