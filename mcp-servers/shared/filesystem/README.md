# Filesystem MCP Server

Node.js server implementing Model Context Protocol (MCP) for filesystem operations.

## Installation

### Method 1: NPM Installation (Recommended)
```powershell
# Install globally
npm install -g @modelcontextprotocol/server-filesystem

# Test installation
npx @modelcontextprotocol/server-filesystem --help
```

### Method 2: From Source
```powershell
# Clone the official MCP servers repository
git clone https://github.com/modelcontextprotocol/servers.git temp-mcp-servers
cd temp-mcp-servers/src/filesystem

# Install dependencies and build
npm install
npm run build

# Copy built files to our structure
Copy-Item -Recurse -Path . -Destination "..\..\..\..\filesystem\"
cd ..\..\..\..
Remove-Item -Recurse -Force temp-mcp-servers
```

## Features

### Tools
- **read_file**: Read the complete contents of a file from an allowed directory
- **read_multiple_files**: Read multiple files simultaneously with optional ordering and filtering
- **write_file**: Create a new file or completely overwrite an existing file with new content
- **edit_file**: Make line-based edits to an existing file (replaces specified line ranges)
- **create_directory**: Create a new directory or ensure a directory exists
- **list_directory**: Get directory contents including files, subdirectories, sizes, permissions, and metadata
- **list_allowed_directories**: List all directories the server is allowed to access
- **move_file**: Move or rename files and directories within allowed paths
- **search_files**: Search for files and directories with glob pattern matching
- **get_file_info**: Get detailed metadata about files and directories

### Resources
The server provides directory contents as resources following the pattern:
- `file://{path}` - Individual file contents
- `directory://{path}` - Directory structure and metadata

## Configuration

The server supports these command-line arguments:
- `--allowed-directories`: Directories the server is allowed to access (can be specified multiple times)
- `--help`: Show usage information

## Claude Desktop Integration

Add this to your Claude Desktop config file:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\Users",
        "C:\\github\\MCP",
        "C:\\temp"
      ]
    }
  }
}
```

## Security Considerations

- The server only operates within allowed directories specified during startup
- No access to files outside the configured directories
- Read-only access can be enforced through directory permissions
- Supports sandboxed operations for safe AI interactions

## Usage

Once configured, the Filesystem server enables:
- **File Management**: Create, read, write, edit, and move files
- **Directory Operations**: List contents, create directories, search patterns
- **File Discovery**: Search with glob patterns and get detailed metadata
- **Batch Operations**: Read multiple files simultaneously
- **Safe Sandboxing**: Restricted access to only allowed directories

## Status

🟢 **READY FOR GRID PATROL**
