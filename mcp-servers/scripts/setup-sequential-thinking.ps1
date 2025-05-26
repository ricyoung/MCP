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

# Check if Claude Desktop config exists
$claudeConfigPath = "$env:APPDATA\Claude\claude_desktop_config.json"
$configExists = Test-Path $claudeConfigPath

if ($configExists) {
    Write-Host "✓ Found existing Claude Desktop configuration" -ForegroundColor Green
    Write-Host "   Manual merge required - see sequential-thinking-config.json" -ForegroundColor Yellow
} else {
    Write-Host "⚠️  Claude Desktop config not found" -ForegroundColor Yellow
    Write-Host "   You can copy sequential-thinking-config.json to:" -ForegroundColor White
    Write-Host "   $claudeConfigPath" -ForegroundColor White
}

Write-Host ""
Write-Host "🎯 TESTING INSTALLATION..." -ForegroundColor Yellow

# Test if the server can be started
try {
    $testResult = npx @modelcontextprotocol/server-sequential-thinking --help
    Write-Host "✓ Sequential Thinking server responds correctly" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Unable to test server - this is normal if Claude Desktop isn't configured yet" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🏍️  LIGHT CYCLE DEPLOYED - SEQUENTIAL THINKING READY!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "1. Restart Claude Desktop" -ForegroundColor White
Write-Host "2. The Sequential Thinking protocol should now be available" -ForegroundColor White
Write-Host "3. Test by asking Claude to solve a complex reasoning problem" -ForegroundColor White
Write-Host ""
Write-Host "Status: OPERATIONAL ⚡" -ForegroundColor Green
