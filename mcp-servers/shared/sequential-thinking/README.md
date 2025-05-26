# Sequential Thinking MCP Server

Enhanced reasoning and problem-solving through dynamic thought sequences.

## Installation

### Method 1: NPM Installation (Recommended)
```powershell
# Install globally
npm install -g @modelcontextprotocol/server-sequential-thinking

# Or install locally in this directory
npm install @modelcontextprotocol/server-sequential-thinking
```

### Method 2: From Source
```powershell
# Clone the official MCP servers repository
git clone https://github.com/modelcontextprotocol/servers.git temp-mcp-servers
cd temp-mcp-servers/src/sequential-thinking

# Install dependencies and build
npm install
npm run build

# Copy built files to our structure
Copy-Item -Recurse -Path . -Destination "..\..\..\..\sequential-thinking\"
cd ..\..\..\..
Remove-Item -Recurse -Force temp-mcp-servers
```

## Configuration

The server supports these environment variables:
- `SEQUENTIAL_THINKING_MAX_DEPTH`: Maximum depth of reasoning chains (default: 10)
- `SEQUENTIAL_THINKING_TIMEOUT`: Timeout for each thinking step in milliseconds (default: 30000)
- `SEQUENTIAL_THINKING_MODEL`: Preferred reasoning model (optional)

## Claude Desktop Integration

Add this to your Claude Desktop config file:
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-sequential-thinking"],
      "env": {
        "SEQUENTIAL_THINKING_MAX_DEPTH": "10",
        "SEQUENTIAL_THINKING_TIMEOUT": "30000"
      }
    }
  }
}
```

## Usage

Once configured, the Sequential Thinking server enhances reasoning by:
- Breaking down complex problems into sequential steps
- Maintaining context across reasoning chains
- Providing reflective analysis of thought processes
- Enabling dynamic problem-solving approaches

## Status

🟢 **READY FOR GRID PATROL**
