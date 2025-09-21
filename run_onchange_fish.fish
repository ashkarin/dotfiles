#!/usr/bin/env fish
# Update all Fisher plugins

# Check if Fisher is installed
if not type -q fisher
    echo "❌ Fisher is not installed. Please install it first: https://github.com/jorgebucaran/fisher"
    exit 1
end

echo "🔄 Updating Fisher plugins..."
fisher update

echo "✅ Fisher plugin update complete!"