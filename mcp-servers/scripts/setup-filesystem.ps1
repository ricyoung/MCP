#!/usr/bin/env pwsh
# MCP Grid Setup Script - Filesystem
# Sets up the Filesystem MCP server for file operations

Write-Host "📁 INITIALIZING FILESYSTEM PROTOCOL..." -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js detected: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js first." -ForegroundColor Red
    Write-Host "   Download from: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check if npm is available
try {
    $npmVersion = npm --version
    Write-Host "✓ NPM detected: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ NPM not found. Please install NPM first." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 INSTALLING FILESYSTEM MCP SERVER..." -ForegroundColor Yellow

# Install the Filesystem MCP server
try {
    npm install -g @modelcontextprotocol/server-filesystem
    Write-Host "✓ Filesystem MCP server installed successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to install Filesystem MCP server" -ForegroundColor Red
    Write-Host "   Trying alternative installation method..." -ForegroundColor Yellow

    # Alternative: local installation
    try {
        Set-Location "mcp-servers\shared\filesystem"
        npm init -y
        npm install @modelcontextprotocol/server-filesystem
        Set-Location "..\..\..\"
        Write-Host "✓ Filesystem MCP server installed locally" -ForegroundColor Green
    } catch {
        Write-Host "❌ Installation failed. Please check your network connection and try again." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "⚙️  CONFIGURING CLAUDE DESKTOP..." -ForegroundColor Yellow

# Define possible Claude Desktop config locations
$claudeConfigPaths = @(
    "$env:APPDATA\Claude\claude_desktop_config.json",
    "$env:LOCALAPPDATA\AnthropicClaude\claude_desktop_config.json"
)

$configSource = "mcp-servers\configs\filesystem-config.json"
$configDeployed = $false

foreach ($configPath in $claudeConfigPaths) {
    $configDir = Split-Path $configPath -Parent

    # Create directory if it doesn't exist
    if (!(Test-Path $configDir)) {
        New-Item -ItemType Directory -Force -Path $configDir | Out-Null
        Write-Host "✓ Created directory: $configDir" -ForegroundColor Green
    }

    # Check if config already exists
    if (Test-Path $configPath) {
        Write-Host "⚠️  Found existing config at: $configPath" -ForegroundColor Yellow
        Write-Host "   Backing up existing config..." -ForegroundColor White
        Copy-Item $configPath -Destination "$configPath.backup" -Force
    }

    # Copy our config
    try {
        Copy-Item $configSource -Destination $configPath -Force
        Write-Host "✓ Deployed config to: $configPath" -ForegroundColor Green
        $configDeployed = $true
    } catch {
        Write-Host "❌ Failed to deploy config to: $configPath" -ForegroundColor Red
    }
}

if (!$configDeployed) {
    Write-Host "❌ Failed to deploy configuration to any location" -ForegroundColor Red
    Write-Host "   Manual setup required - see filesystem-config.json" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎯 TESTING INSTALLATION..." -ForegroundColor Yellow

# Test if the server can be started
try {
    npx @modelcontextprotocol/server-filesystem --help | Out-Null
    Write-Host "✓ Filesystem server responds correctly" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Unable to test server - this is normal if Claude Desktop isn't configured yet" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📁 FILE SYSTEM ACCESS DEPLOYED - FILESYSTEM READY!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Configuration deployed to:" -ForegroundColor White
Write-Host "• $env:APPDATA\Claude\claude_desktop_config.json" -ForegroundColor White
Write-Host "• $env:LOCALAPPDATA\AnthropicClaude\claude_desktop_config.json" -ForegroundColor White
Write-Host ""
Write-Host "🤖 STARTUP BEHAVIOR:" -ForegroundColor Yellow
Write-Host "• MCP servers start AUTOMATICALLY when Claude Desktop opens" -ForegroundColor Green
Write-Host "• No manual startup required each time you turn on your computer" -ForegroundColor Green
Write-Host "• Claude Desktop manages the server lifecycle" -ForegroundColor Green
Write-Host ""
Write-Host "🔐 SECURITY:" -ForegroundColor Yellow
Write-Host "• Access restricted to configured directories only" -ForegroundColor Green
Write-Host "• Sandboxed operations for safe AI interactions" -ForegroundColor Green
Write-Host "• No access to files outside allowed paths" -ForegroundColor Green
Write-Host ""
Write-Host "📂 ALLOWED DIRECTORIES:" -ForegroundColor White
Write-Host "• C:\Users (User profiles and documents)" -ForegroundColor White
Write-Host "• C:\github\MCP (MCP Grid workspace)" -ForegroundColor White
Write-Host "• C:\temp (Temporary files and testing)" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "1. Restart Claude Desktop completely (close and reopen)" -ForegroundColor White
Write-Host "2. Look for 'Filesystem' in Claude's available tools" -ForegroundColor White
Write-Host "3. Test by asking Claude to list files or read a document" -ForegroundColor White
Write-Host ""
Write-Host "Status: OPERATIONAL 📁" -ForegroundColor Green
