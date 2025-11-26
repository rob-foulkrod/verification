# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Dockerfile for GitHub Actions - Educational Demo
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# This Dockerfile demonstrates best practices for creating a Docker-based
# GitHub Action using Alpine Linux as the base image.
#
# Why Alpine?
# -----------
# • Minimal size (~5MB base image vs ~70MB for Ubuntu)
# • Fast downloads and container startup
# • Security-focused with minimal attack surface
# • Contains essential tools (sh, basic utilities)
# • apk package manager for adding tools as needed
#
# Docker Action Concepts:
# -----------------------
# • Container is built when the action runs (or uses pre-built image)
# • Provides complete environment isolation
# • Can use any language or tool (not just Node.js/shell)
# • Slower startup than JavaScript actions (container overhead)
# • Perfect for specific tool versions or complex dependencies
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# BASE IMAGE SELECTION
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Use Alpine Linux 3.18 - latest stable version
# Pin to a specific version for reproducibility
# Format: alpine:<version> or alpine:latest (not recommended for production)
FROM alpine:3.18

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# LABELS - METADATA FOR THE IMAGE
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Labels provide metadata about the image
# Follow OCI (Open Container Initiative) annotation standards
LABEL maintainer="GitHub Actions Learning Repository"
LABEL description="Educational Docker action demonstrating containerized GitHub Actions"
LABEL version="1.0.0"

# Additional labels following OCI standards
LABEL org.opencontainers.image.title="Demo Docker Action"
LABEL org.opencontainers.image.description="Educational Docker action for learning"
LABEL org.opencontainers.image.version="1.0.0"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# INSTALL DEPENDENCIES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Install required packages using apk (Alpine Package Keeper)
# 
# Best Practices:
# • Combine RUN commands to reduce layers (smaller image)
# • Clean up cache after installation (--no-cache or rm -rf /var/cache/apk/*)
# • Install only what you need
# • Pin versions for reproducibility (optional: bash=5.2.15-r5)
#
# Common packages for GitHub Actions:
# • bash - Better shell scripting than sh
# • curl - HTTP requests and downloads
# • git - Version control operations
# • jq - JSON parsing and manipulation
# • ca-certificates - HTTPS support

RUN apk add --no-cache \
    bash=~5.2 \
    curl=~8.5 \
    jq=~1.6 \
    ca-certificates \
    coreutils \
    && echo "Dependencies installed successfully"

# Why --no-cache?
# It prevents caching of package index, keeping the image smaller.
# Without it, you'd need: apk update && apk add ... && rm -rf /var/cache/apk/*

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# COPY ENTRYPOINT SCRIPT
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Copy the entrypoint script from the host to the container
# COPY <source> <destination>
# Source is relative to the build context (same directory as Dockerfile)
# Destination is absolute path in the container
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
# This is crucial - without it, the container will fail to start
RUN chmod +x /entrypoint.sh

# Alternative: Set permissions in git before COPY
# git update-index --chmod=+x entrypoint.sh

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SET WORKING DIRECTORY
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Set the working directory for the container
# GitHub Actions maps the workspace directory here
# GITHUB_WORKSPACE environment variable points to this location
WORKDIR /github/workspace

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ENTRYPOINT - WHAT RUNS WHEN THE CONTAINER STARTS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ENTRYPOINT defines the command that runs when the container starts
# The args from action.yml are passed to this script as $1, $2, $3, etc.
#
# ENTRYPOINT vs CMD:
# • ENTRYPOINT: Main command (not easily overridden)
# • CMD: Default arguments to ENTRYPOINT (easily overridden)
# • Both together: ENTRYPOINT is the command, CMD is default args
# 
# For GitHub Actions, use ENTRYPOINT with the script path
ENTRYPOINT ["/entrypoint.sh"]

# Optional: Default CMD (used if no args provided)
# CMD ["default-arg"]

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DOCKER ACTION FLOW SUMMARY
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# When a Docker action runs:
# 1. GitHub Actions builds this Dockerfile (or pulls pre-built image)
# 2. Creates a container from the image
# 3. Maps GITHUB_WORKSPACE to /github/workspace
# 4. Passes environment variables (inputs, GITHUB_*, etc.)
# 5. Runs ENTRYPOINT with args from action.yml
# 6. Collects outputs from GITHUB_OUTPUT file
# 7. Stops and removes the container
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
