# syntax=docker/dockerfile:1
# check=error=true

# Modern Containerfile for Rails 8.1 application
# This Containerfile follows OCI standards and Rails best practices
# 
# Build: podman build -t tummy .
# Run: podman run -d -p 3000:80 \
#   -e RAILS_MASTER_KEY=<value from config/master.key> \
#   -v ./data:/rails/storage \
#   --name tummy tummy

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.7
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages needed for runtime
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    sqlite3 \
    gosu \
    && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment variables and enable jemalloc for reduced memory usage
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so" \
    RAILS_LOG_TO_STDOUT="true" \
    RAILS_SERVE_STATIC_FILES="true"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libyaml-dev \
    pkg-config \
    && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
# Copy dependency files first for better layer caching
COPY Gemfile Gemfile.lock ./
COPY vendor ./vendor

# Install gems and clean up build artifacts
RUN bundle install && \
    rm -rf ~/.bundle/ \
    "${BUNDLE_PATH}"/ruby/*/cache \
    "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    # Precompile bootsnap for faster boot times
    # -j 1 disables parallel compilation to avoid QEMU bug: https://github.com/rails/bootsnap/issues/495
    bundle exec bootsnap precompile -j 1 --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile -j 1 app/ lib/

# Precompile assets for production without requiring secret RAILS_MASTER_KEY
# This allows the image to be built without credentials
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Accept TUMMY_VERSION as build argument
ARG TUMMY_VERSION

# Create non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Copy built artifacts: gems, application
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

# Set TUMMY_VERSION as environment variable if provided during build
ENV TUMMY_VERSION=${TUMMY_VERSION}

# Create storage directory with proper permissions for volume mounting
# This directory will be used for SQLite databases and Active Storage files
RUN mkdir -p /rails/storage && \
    chown -R rails:rails /rails/storage && \
    chmod 755 /rails/storage

# Make wrapper entrypoint executable
RUN chmod +x /rails/bin/docker-entrypoint-wrapper

# Start as root to fix volume permissions, then switch to rails user
# The wrapper entrypoint handles permission fixes and user switching
USER root

# Entrypoint wrapper fixes permissions as root, then switches to rails user
ENTRYPOINT ["/rails/bin/docker-entrypoint-wrapper"]

# Expose port 80 (Thruster/Puma will listen here)
EXPOSE 80

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost/up || exit 1

# Start server via Thruster by default, this can be overwritten at runtime
CMD ["./bin/thrust", "./bin/rails", "server", "-b", "0.0.0.0"]

