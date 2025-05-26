#!/bin/bash
# MCP Grid - Combined Server Testing Script (Linux)
# Tests both Sequential Thinking and Filesystem MCP servers

echo "⚡ MCP GRID - COMBINED SERVER TESTING ⚡"
echo "============================================="
echo ""

# Test Node.js and npm availability
echo "🔍 CHECKING PREREQUISITES..."
echo ""

if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js: $NODE_VERSION"
else
    echo "❌ Node.js not found. Please install Node.js first."
    echo "   Ubuntu/Debian: sudo apt update && sudo apt install nodejs npm"
    echo "   CentOS/RHEL: sudo yum install nodejs npm"
    echo "   Arch Linux: sudo pacman -S nodejs npm"
    exit 1
fi

if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "✅ npm: v$NPM_VERSION"
else
    echo "❌ npm not found. Please install npm first."
    exit 1
fi

echo ""

# Test Sequential Thinking Server
echo "🧠 TESTING SEQUENTIAL THINKING SERVER..."
echo ""

if npx @modelcontextprotocol/server-sequential-thinking --help &> /dev/null; then
    echo "✅ Sequential Thinking server: AVAILABLE"
else
    echo "❌ Sequential Thinking server: NOT AVAILABLE"
    echo "   Installing now..."
    npm install -g @modelcontextprotocol/server-sequential-thinking
fi

# Test Filesystem Server
echo "📁 TESTING FILESYSTEM SERVER..."
echo ""

if npx @modelcontextprotocol/server-filesystem --help &> /dev/null; then
    echo "✅ Filesystem server: AVAILABLE"
else
    echo "❌ Filesystem server: NOT AVAILABLE"
    echo "   Installing now..."
    npm install -g @modelcontextprotocol/server-filesystem
fi

echo ""

# Test configuration files
echo "⚙️ CHECKING CONFIGURATION FILES..."
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="$SCRIPT_DIR/../configs/combined-config.json"

if [ -f "$CONFIG_PATH" ]; then
    echo "✅ Combined config file: EXISTS"
    echo "   Path: $CONFIG_PATH"
else
    echo "❌ Combined config file: NOT FOUND"
    echo "   Expected: $CONFIG_PATH"
fi

# Check Claude Desktop config
CLAUDE_CONFIG_PATHS=(
    "$HOME/.config/Claude/claude_desktop_config.json"
    "$HOME/.local/share/Claude/claude_desktop_config.json"
)

echo ""
echo "🔍 CHECKING CLAUDE DESKTOP CONFIGURATION..."
echo ""

CONFIG_DEPLOYED=false
for CONFIG_PATH in "${CLAUDE_CONFIG_PATHS[@]}"; do
    if [ -f "$CONFIG_PATH" ]; then
        echo "✅ Claude config found: $CONFIG_PATH"
        CONFIG_DEPLOYED=true

        # Check if config contains our servers (basic grep since jq might not be available)
        if grep -q "sequential-thinking" "$CONFIG_PATH" 2>/dev/null; then
            echo "   ✅ Sequential Thinking: CONFIGURED"
        else
            echo "   ❌ Sequential Thinking: NOT CONFIGURED"
        fi

        if grep -q "filesystem" "$CONFIG_PATH" 2>/dev/null; then
            echo "   ✅ Filesystem: CONFIGURED"
        else
            echo "   ❌ Filesystem: NOT CONFIGURED"
        fi
        break
    fi
done

if [ "$CONFIG_DEPLOYED" = false ]; then
    echo "❌ No Claude Desktop config found"
    echo "   Checked paths:"
    for CONFIG_PATH in "${CLAUDE_CONFIG_PATHS[@]}"; do
        echo "   - $CONFIG_PATH"
    done
fi

echo ""

# Test directory permissions for filesystem server
echo "🔒 TESTING FILESYSTEM PERMISSIONS..."
echo ""

TEST_DIRS=(
    "$HOME"
    "$HOME/github/MCP"
    "/tmp"
)

for DIR in "${TEST_DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        if [ -r "$DIR" ]; then
            echo "✅ Directory accessible: $DIR"
        else
            echo "⚠️ Directory access limited: $DIR"
        fi
    else
        echo "❌ Directory not found: $DIR"
        if [ "$DIR" = "$HOME/github/MCP" ]; then
            echo "   Creating MCP directory..."
            mkdir -p "$DIR" 2>/dev/null && echo "   ✅ Created: $DIR" || echo "   ❌ Failed to create: $DIR"
        fi
    fi
done

echo ""

# Check if jq is available for better JSON parsing
if ! command -v jq &> /dev/null; then
    echo "💡 TIP: Install 'jq' for better config file validation:"
    echo "   Ubuntu/Debian: sudo apt install jq"
    echo "   CentOS/RHEL: sudo yum install jq"
    echo "   Arch Linux: sudo pacman -S jq"
    echo ""
fi

# Summary
echo "📊 TEST SUMMARY"
echo "============================================="
echo ""

echo "🧠 Sequential Thinking MCP Server:"
echo "   • Test with: 'Can you walk me through solving this step-by-step'"
echo "   • Look for structured, numbered reasoning steps"
echo ""

echo "📁 Filesystem MCP Server:"
echo "   • Test with: 'Can you list the contents of my Documents folder?'"
echo "   • Look for directory listings and file operations"
echo ""

echo "🔄 Combined Usage:"
echo "   • Test with: 'Use sequential thinking to help me organize my files'"
echo "   • Should see both reasoning and file operations working together"
echo ""

echo "⚠️ Remember: Restart Claude Desktop after configuration changes!"
echo ""

echo "⚡ MCP GRID TESTING COMPLETE ⚡"
