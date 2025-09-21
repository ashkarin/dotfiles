#!/bin/bash
set -eufo pipefail

# Path to backup the current shell
zdot="$HOME"

# Fish shell binary (update path if different on your system)
fish_shell="$(which fish)"

if [ -z "$fish_shell" ]; then
  echo "❌ Fish shell not found. Please install fish first."
  exit 1
fi

# Backup the current shell
if [ -n "$SHELL" ]; then
  echo "$SHELL" > "$zdot/.shell.pre-fish"
else
  grep "^$USER:" /etc/passwd | awk -F: '{print $7}' > "$zdot/.shell.pre-fish"
fi

echo "🔄 Changing your shell to Fish ($fish_shell)..."

# Function to check if user can sudo
user_can_sudo() {
  sudo -n true 2>/dev/null
}

# Change shell using chsh
if user_can_sudo; then
  sudo -k chsh -s "$fish_shell" "$USER"  # -k forces password prompt
else
  chsh -s "$fish_shell" "$USER"
fi

# Verify if shell change succeeded
if [ $? -ne 0 ]; then
  echo "❌ chsh command unsuccessful. Change your default shell manually."
else
  export SHELL="$fish_shell"
  echo "✅ Shell successfully changed to '$fish_shell'."
fi

echo
