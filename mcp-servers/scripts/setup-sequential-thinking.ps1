#!/usr/bin/env pwsh
# MCP Grid Setup Script - Sequential Thinking
# Sets up the Sequential Thinking MCP server for enhanced reasoning

Write-Host "🔵 INITIALIZING SEQUENTIAL THINKING PROTOCOL..." -ForegroundColor Cyan
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
Write-Host "🚀 INSTALLING SEQUENTIAL THINKING MCP SERVER..." -ForegroundColor Yellow

# Install the Sequential Thinking MCP server
try {
    npm install -g @modelcontextprotocol/server-sequential-thinking
    Write-Host "✓ Sequential Thinking MCP server installed successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to install Sequential Thinking MCP server" -ForegroundColor Red
    Write-Host "   Trying alternative installation method..." -ForegroundColor Yellow

    # Alternative: local installation
    try {
        Set-Location "mcp-servers\shared\sequential-thinking"
        npm init -y
        npm install @modelcontextprotocol/server-sequential-thinking
        Set-Location "..\..\..\"
        Write-Host "✓ Sequential Thinking MCP server installed locally" -ForegroundColor Green
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

$configSource = "mcp-servers\configs\sequential-thinking-config.json"
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
    Write-Host "   Manual setup required - see sequential-thinking-config.json" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎯 TESTING INSTALLATION..." -ForegroundColor Yellow

# Test if the server can be started
try {
    npx @modelcontextprotocol/server-sequential-thinking --help | Out-Null
    Write-Host "✓ Sequential Thinking server responds correctly" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Unable to test server - this is normal if Claude Desktop isn't configured yet" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🏍️  LIGHT CYCLE DEPLOYED - SEQUENTIAL THINKING READY!" -ForegroundColor Cyan
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
Write-Host "Next steps:" -ForegroundColor White
Write-Host "1. Restart Claude Desktop completely (close and reopen)" -ForegroundColor White
Write-Host "2. Look for 'Sequential Thinking' in Claude's available tools" -ForegroundColor White
Write-Host "3. Test by asking Claude to solve a complex reasoning problem" -ForegroundColor White
Write-Host ""
Write-Host "Status: OPERATIONAL ⚡" -ForegroundColor Green
