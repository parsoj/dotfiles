#!/bin/bash

# Test script for insert_into_obsidian_heading
# This script sets up a test file with headings to validate the heading selection functionality

set -e

# Define the test file path
OBSIDIAN_VAULT="$HOME/Documents/Obsidian-Synced"
TEST_FILE="$OBSIDIAN_VAULT/Capture_Tests.md"

# Ensure the vault directory exists
if [ ! -d "$OBSIDIAN_VAULT" ]; then
    echo "Error: Obsidian vault not found at $OBSIDIAN_VAULT"
    exit 1
fi

# delete the test file if it exists
echo "Deleting test file if it exists..."
rm "$TEST_FILE" 2>/dev/null || true

# create the test file - with a some headings
touch "$TEST_FILE"
echo "# Heading 1" >> "$TEST_FILE"
echo "# Heading 2" >> "$TEST_FILE"
echo "# Heading 3" >> "$TEST_FILE"
echo "Test file created successfully!"

# Now run the script in non-interactive mode using command-line arguments
echo "Running the script with test input..."

# Use command-line arguments to specify file and heading
# Use relative path to the test file from the vault
echo "Test Capture from $(date)" | ./insert_into_obsidian_heading --file "Capture_Tests.md" --heading 2

# If the above command fails or hangs, you can try:
# echo "Test Capture from $(date)" | ./insert_into_obsidian_heading --file "$OBSIDIAN_VAULT/Capture_Tests.md" --heading 2

# Check if the script ran successfully
echo "Checking if the script ran successfully..."
if [ $? -eq 0 ]; then
    echo "Script ran successfully!"
else
    echo "Script failed!"
    exit 1
fi

# print out the contents of the test file
echo "Contents of test file:"
cat "$TEST_FILE"