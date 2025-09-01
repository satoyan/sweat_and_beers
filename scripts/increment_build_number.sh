#!/bin/bash

# Exit on error
set -e

# Check if the git working directory is clean
if ! git diff-index --quiet HEAD --; then
  echo "Git working directory is not clean. Please commit or stash your changes."
  exit 1
fi

# Read the current version from pubspec.yaml
CURRENT_VERSION=$(awk '/version:/ {print $2}' pubspec.yaml)

# Split the version into version name and build number
VERSION_NAME=$(echo $CURRENT_VERSION | cut -d+ -f1)
BUILD_NUMBER=$(echo $CURRENT_VERSION | cut -d+ -f2)

# Increment the build number
NEW_BUILD_NUMBER=$(($BUILD_NUMBER + 1))

# Create the new version string
NEW_VERSION=$VERSION_NAME+$NEW_BUILD_NUMBER

# Update pubspec.yaml with the new version
sed -i '' "s/version: .*/version: $NEW_VERSION/" pubspec.yaml

# Commit the changes
git add pubspec.yaml
git commit -m "chore: increment build number to $NEW_BUILD_NUMBER"

echo "Build number incremented to $NEW_BUILD_NUMBER"
echo "Full Version is $NEW_VERSION"
