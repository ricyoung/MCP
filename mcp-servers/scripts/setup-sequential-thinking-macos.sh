#!/bin/bash
# MCP Grid Setup Script - Sequential Thinking (macOS/Linux)
# Sets up the Sequential Thinking MCP server for enhanced reasoning

echo "🔵 INITIALIZING SEQUENTIAL THINKING PROTOCOL..."
echo ""

# Check if Node.js is installed
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✓ Node.js detected: $NODE_VERSION"
else
    echo "❌ Node.js not found. Please install Node.js first."
    echo "   Download from: https://nodejs.org/"
    echo "   Or install via Homebrew: brew install node"
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
echo "🚀 INSTALLING SEQUENTIAL THINKING MCP SERVER..."

# Install the Sequential Thinking MCP server
if npm install -g @modelcontextprotocol/server-sequential-thinking; then
    echo "✓ Sequential Thinking MCP server installed successfully"
else
    echo "❌ Failed to install Sequential Thinking MCP server"
    echo "   Trying alternative installation method..."

    # Alternative: local installation
    if mkdir -p mcp-servers/shared/sequential-thinking && \
       cd mcp-servers/shared/sequential-thinking && \
       npm init -y && \
       npm install @modelcontextprotocol/server-sequential-thinking && \
       cd ../../..; then
        echo "✓ Sequential Thinking MCP server installed locally"
    else
        echo "❌ Installation failed. Please check your network connection and try again."
        exit 1
    fi
fi

echo ""
echo "⚙️  CONFIGURING CLAUDE DESKTOP..."

# Define Claude Desktop config path for macOS
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG_PATH="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
CONFIG_SOURCE="mcp-servers/configs/sequential-thinking-config.json"

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
    echo "   Manual setup required - see sequential-thinking-config.json"
    exit 1
fi

echo ""
echo "🎯 TESTING INSTALLATION..."

# Test if the server can be started
if npx @modelcontextprotocol/server-sequential-thinking --help &> /dev/null; then
    echo "✓ Sequential Thinking server responds correctly"
else
    echo "⚠️  Unable to test server - this is normal if Claude Desktop isn't configured yet"
fi

echo ""
echo "🏍️  LIGHT CYCLE DEPLOYED - SEQUENTIAL THINKING READY!"
echo ""
echo "Configuration deployed to:"
echo "• $CLAUDE_CONFIG_PATH"
echo ""
echo "🤖 STARTUP BEHAVIOR:"
echo "• MCP servers start AUTOMATICALLY when Claude Desktop opens"
echo "• No manual startup required each time you turn on your computer"
echo "• Claude Desktop manages the server lifecycle"
echo ""
echo "Next steps:"
echo "1. Restart Claude Desktop completely (close and reopen)"
echo "2. Look for 'Sequential Thinking' in Claude's available tools"
echo "3. Test by asking Claude to solve a complex reasoning problem"
echo ""
echo "Status: OPERATIONAL ⚡"
