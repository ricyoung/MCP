#!/bin/bash
# MCP Grid Setup Script - Sequential Thinking for Ollama
# Sets up the Sequential Thinking MCP server for use with Ollama

echo "🦙 INITIALIZING SEQUENTIAL THINKING FOR OLLAMA..."
echo ""

# Check if Node.js is installed
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✓ Node.js detected: $NODE_VERSION"
else
    echo "❌ Node.js not found. Please install Node.js first."
    echo "   Download from: https://nodejs.org/"
    echo "   Or use your system package manager"
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

# Check if Ollama is installed
if command -v ollama &> /dev/null; then
    echo "✓ Ollama detected"
else
    echo "⚠️  Ollama not found. Install Ollama first:"
    echo "   Visit: https://ollama.ai/"
    echo "   Or use: curl -fsSL https://ollama.ai/install.sh | sh"
    echo ""
    echo "   Continuing with MCP server installation..."
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
echo "🎯 TESTING INSTALLATION..."

# Test if the server can be started
if npx @modelcontextprotocol/server-sequential-thinking --help &> /dev/null; then
    echo "✓ Sequential Thinking server responds correctly"
else
    echo "⚠️  Unable to test server - this may be normal"
fi

echo ""
echo "🦙 OLLAMA + SEQUENTIAL THINKING SETUP COMPLETE!"
echo ""
echo "🔧 INTEGRATION OPTIONS:"
echo ""
echo "1. 📱 Use with Open WebUI:"
echo "   • Open WebUI supports MCP server integration"
echo "   • Configure Open WebUI to connect to MCP servers"
echo "   • Enhanced reasoning will supplement Ollama responses"
echo ""
echo "2. 🔗 Custom Application Integration:"
echo "   • Start MCP server: npx @modelcontextprotocol/server-sequential-thinking"
echo "   • Build bridge between Ollama API and MCP protocol"
echo "   • Use tools like LangChain for workflow integration"
echo ""
echo "3. 🛠️ Manual Usage:"
echo "   • Run MCP server in one terminal"
echo "   • Use Ollama in another terminal"
echo "   • Combine outputs for enhanced reasoning"
echo ""
echo "📖 EXAMPLE USAGE:"
echo "   Ask your Ollama-powered application:"
echo "   'Use sequential thinking to analyze this problem step by step'"
echo ""
echo "Status: READY FOR OLLAMA INTEGRATION 🦙⚡"
