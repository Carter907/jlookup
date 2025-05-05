#!/bin/bash

# Installation script for jlookup

# --- Configuration ---
# The name of the script file to install
SOURCE_SCRIPT="jlookup.sh"
# The desired name for the command after installation
TARGET_COMMAND="jlookup"
# The target directory for installation (common practice for user-installed executables)
INSTALL_DIR="/usr/local/bin"

# --- Pre-checks ---

# 1. Check if the source script exists in the current directory
if [ ! -f "$SOURCE_SCRIPT" ]; then
  printf "Error: Source script '%s' not found in the current directory.\n" "$SOURCE_SCRIPT" >&2
  printf "Please run this installer from the same directory where '%s' is located.\n" "$SOURCE_SCRIPT" >&2
  exit 1
fi

# 2. Check if the target directory exists
if [ ! -d "$INSTALL_DIR" ]; then
  printf "Error: Installation directory '%s' not found.\n" "$INSTALL_DIR" >&2
  printf "You may need to create it first (e.g., 'sudo mkdir -p %s').\n" "$INSTALL_DIR" >&2
  exit 1
fi

# 3. Check for write permissions (usually requires sudo for /usr/local/bin)
if [ ! -w "$INSTALL_DIR" ]; then
  printf "Error: Write permission denied for installation directory '%s'.\n" "$INSTALL_DIR" >&2
  printf "Please run this script with sudo: 'sudo ./install.sh'\n" >&2
  exit 1
fi

# --- Installation ---

TARGET_PATH="$INSTALL_DIR/$TARGET_COMMAND"

printf "Attempting to install '%s' to '%s'...\n" "$SOURCE_SCRIPT" "$TARGET_PATH"

# Copy the script
cp "$SOURCE_SCRIPT" "$TARGET_PATH"
if [ $? -ne 0 ]; then
  printf "Error: Failed to copy '%s' to '%s'.\n" "$SOURCE_SCRIPT" "$TARGET_PATH" >&2
  exit 1
fi
printf "Script copied successfully.\n"

# Make the script executable
chmod +x "$TARGET_PATH"
if [ $? -ne 0 ]; then
  printf "Error: Failed to make '%s' executable.\n" "$TARGET_PATH" >&2
  # Attempt to clean up by removing the copied file
  rm "$TARGET_PATH" 2>/dev/null
  exit 1
fi
printf "Script '%s' made executable.\n" "$TARGET_PATH"

# --- Success ---

printf "\nInstallation complete!\n"
printf "You can now run the tool by typing: %s\n" "$TARGET_COMMAND"

exit 0
