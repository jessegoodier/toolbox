#!/bin/bash
set -eo pipefail

# Get today's date
TODAY=$(date +%Y-%m-%d)
# Check if running in CI or local (default to local dry run unless specified)
PUSH=${PUSH:-false}

echo "Building images with tags: latest, $TODAY"
echo "Push enabled: $PUSH"

# Create a buildx builder if one doesn't exist (needed for multi-arch)
# In CI, we expect the environment to be set up by actions, so we skip this.
if [ -z "$CI" ]; then
  if ! docker buildx inspect toolbox-builder > /dev/null 2>&1; then
    echo "Creating new buildx builder 'toolbox-builder'..."
    # Use docker-container driver to support multi-arch
    docker buildx create --name toolbox-builder --use --driver docker-container
    docker buildx inspect --bootstrap
  else
    docker buildx use toolbox-builder
  fi
fi

# Build arguments
ARGS=""
if [ "$PUSH" = "true" ]; then
    ARGS="--push"
fi

# Run bake
# Pass DATE_TAG to override the default "latest" for the second tag
DATE_TAG=$TODAY docker buildx bake $ARGS

echo "Build complete."
