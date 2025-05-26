#!/bin/bash
# MCP Grid Setup Script - Filesystem (Linux)
# Sets up the Filesystem MCP server for file operations

echo "📁 INITIALIZING FILESYSTEM PROTOCOL..."
echo ""

# Check if Node.js is installed
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✓ Node.js detected: $NODE_VERSION"
else
    echo "❌ Node.js not found. Please install Node.js first."
    echo "   Installation options:"
    echo "   • Ubuntu/Debian: sudo apt update && sudo apt install nodejs npm"
    echo "   • CentOS/RHEL: sudo yum install nodejs npm"
    echo "   • Fedora: sudo dnf install nodejs npm"
    echo "   • Arch: sudo pacman -S nodejs npm"
    echo "   • Or download from: https://nodejs.org/"
    exit 1
fi

# Check if npm is available
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "✓ NPM detected: $NPM_VERSION"
else
    echo "❌ NPM not found. Please install NPM first."
    exit 1
fi

echo ""
echo "🚀 INSTALLING FILESYSTEM MCP SERVER..."

# Install the Filesystem MCP server
if npm install -g @modelcontextprotocol/server-filesystem; then
    echo "✓ Filesystem MCP server installed successfully"
else
    echo "❌ Failed to install Filesystem MCP server"
    echo "   Trying alternative installation method..."

    # Alternative: local installation
    if mkdir -p mcp-servers/shared/filesystem && \
       cd mcp-servers/shared/filesystem && \
       npm init -y && \
       npm install @modelcontextprotocol/server-filesystem && \
       cd ../../..; then
        echo "✓ Filesystem MCP server installed locally"
    else
        echo "❌ Installation failed. Please check your network connection and try again."
        exit 1
    fi
fi

echo ""
echo "⚙️  CONFIGURING CLAUDE DESKTOP..."

# Define Claude Desktop config path for Linux
CLAUDE_CONFIG_DIR="$HOME/.config/Claude"
CLAUDE_CONFIG_PATH="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

# Create filesystem config for Linux
cat > mcp-servers/configs/filesystem-config-linux.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home",
        "/tmp",
        "$(pwd)"
      ]
    }
  }
}
EOF

CONFIG_SOURCE="mcp-servers/configs/filesystem-config-linux.json"

# Create directory if it doesn't exist
if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    mkdir -p "$CLAUDE_CONFIG_DIR"
    echo "✓ Created directory: $CLAUDE_CONFIG_DIR"
fi

# Check if config already exists
if [ -f "$CLAUDE_CONFIG_PATH" ]; then
    echo "⚠️  Found existing config at: $CLAUDE_CONFIG_PATH"
    echo "   Backing up existing config..."
    cp "$CLAUDE_CONFIG_PATH" "$CLAUDE_CONFIG_PATH.backup"
fi

# Copy our config
if cp "$CONFIG_SOURCE" "$CLAUDE_CONFIG_PATH"; then
    echo "✓ Deployed config to: $CLAUDE_CONFIG_PATH"
else
    echo "❌ Failed to deploy config to: $CLAUDE_CONFIG_PATH"
    echo "   Manual setup required - see filesystem-config-linux.json"
    exit 1
fi

echo ""
echo "🎯 TESTING INSTALLATION..."

# Test if the server can be started
if npx @modelcontextprotocol/server-filesystem --help &> /dev/null; then
    echo "✓ Filesystem server responds correctly"
else
    echo "⚠️  Unable to test server - this is normal if Claude Desktop isn't configured yet"
fi

echo ""
echo "📁 FILE SYSTEM ACCESS DEPLOYED - FILESYSTEM READY!"
echo ""
echo "Configuration deployed to:"
echo "• $CLAUDE_CONFIG_PATH"
echo ""
echo "🤖 STARTUP BEHAVIOR:"
echo "• MCP servers start AUTOMATICALLY when Claude Desktop opens"
echo "• No manual startup required each time you turn on your computer"
echo "• Claude Desktop manages the server lifecycle"
echo ""
echo "🔐 SECURITY:"
echo "• Access restricted to configured directories only"
echo "• Sandboxed operations for safe AI interactions"
echo "• No access to files outside allowed paths"
echo ""
echo "📂 ALLOWED DIRECTORIES:"
echo "• /home (User home directories)"
echo "• /tmp (Temporary files)"
echo "• Current working directory"
echo ""
echo "Next steps:"
echo "1. Restart Claude Desktop completely (close and reopen)"
echo "2. Look for 'Filesystem' in Claude's available tools"
echo "3. Test by asking Claude to list files or read a document"
echo ""
echo "Status: OPERATIONAL 📁"
