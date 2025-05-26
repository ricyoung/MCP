#!/usr/bin/env pwsh
# MCP Grid - Combined Server Testing Script
# Tests both Sequential Thinking and Filesystem MCP servers

Write-Host "⚡ MCP GRID - COMBINED SERVER TESTING ⚡" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Test Node.js and npm availability
Write-Host "🔍 CHECKING PREREQUISITES..." -ForegroundColor Yellow
Write-Host ""

try {
    $nodeVersion = node --version 2>$null
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js first." -ForegroundColor Red
    exit 1
}

try {
    $npmVersion = npm --version 2>$null
    Write-Host "✅ npm: v$npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm not found. Please install npm first." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test Sequential Thinking Server
Write-Host "🧠 TESTING SEQUENTIAL THINKING SERVER..." -ForegroundColor Yellow
Write-Host ""

try {
    $sequentialTest = npx @modelcontextprotocol/server-sequential-thinking --help 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Sequential Thinking server: AVAILABLE" -ForegroundColor Green
    } else {
        Write-Host "❌ Sequential Thinking server: NOT AVAILABLE" -ForegroundColor Red
        Write-Host "   Installing now..." -ForegroundColor Yellow
        npm install -g @modelcontextprotocol/server-sequential-thinking
    }
} catch {
    Write-Host "❌ Sequential Thinking server: NOT AVAILABLE" -ForegroundColor Red
    Write-Host "   Installing now..." -ForegroundColor Yellow
    npm install -g @modelcontextprotocol/server-sequential-thinking
}

# Test Filesystem Server
Write-Host "📁 TESTING FILESYSTEM SERVER..." -ForegroundColor Yellow
Write-Host ""

try {
    $filesystemTest = npx @modelcontextprotocol/server-filesystem --help 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Filesystem server: AVAILABLE" -ForegroundColor Green
    } else {
        Write-Host "❌ Filesystem server: NOT AVAILABLE" -ForegroundColor Red
        Write-Host "   Installing now..." -ForegroundColor Yellow
        npm install -g @modelcontextprotocol/server-filesystem
    }
} catch {
    Write-Host "❌ Filesystem server: NOT AVAILABLE" -ForegroundColor Red
    Write-Host "   Installing now..." -ForegroundColor Yellow
    npm install -g @modelcontextprotocol/server-filesystem
}

Write-Host ""

# Test configuration files
Write-Host "⚙️ CHECKING CONFIGURATION FILES..." -ForegroundColor Yellow
Write-Host ""

$configPath = Join-Path $PSScriptRoot "..\configs\combined-config.json"
if (Test-Path $configPath) {
    Write-Host "✅ Combined config file: EXISTS" -ForegroundColor Green
    Write-Host "   Path: $configPath" -ForegroundColor Gray
} else {
    Write-Host "❌ Combined config file: NOT FOUND" -ForegroundColor Red
    Write-Host "   Expected: $configPath" -ForegroundColor Gray
}

# Check Claude Desktop config
$claudeConfigPaths = @(
    "$env:APPDATA\Claude\claude_desktop_config.json",
    "$env:LOCALAPPDATA\AnthropicClaude\claude_desktop_config.json"
)

Write-Host ""
Write-Host "🔍 CHECKING CLAUDE DESKTOP CONFIGURATION..." -ForegroundColor Yellow
Write-Host ""

$configDeployed = $false
foreach ($path in $claudeConfigPaths) {
    if (Test-Path $path) {
        Write-Host "✅ Claude config found: $path" -ForegroundColor Green
        $configDeployed = $true
        
        # Check if config contains our servers
        try {
            $config = Get-Content $path | ConvertFrom-Json
            if ($config.mcpServers."sequential-thinking") {
                Write-Host "   ✅ Sequential Thinking: CONFIGURED" -ForegroundColor Green
            } else {
                Write-Host "   ❌ Sequential Thinking: NOT CONFIGURED" -ForegroundColor Red
            }
            
            if ($config.mcpServers.filesystem) {
                Write-Host "   ✅ Filesystem: CONFIGURED" -ForegroundColor Green
            } else {
                Write-Host "   ❌ Filesystem: NOT CONFIGURED" -ForegroundColor Red
            }
        } catch {
            Write-Host "   ⚠️ Config file exists but couldn't parse JSON" -ForegroundColor Yellow
        }
        break
    }
}

if (-not $configDeployed) {
    Write-Host "❌ No Claude Desktop config found" -ForegroundColor Red
    Write-Host "   Checked paths:" -ForegroundColor Gray
    foreach ($path in $claudeConfigPaths) {
        Write-Host "   - $path" -ForegroundColor Gray
    }
}

Write-Host ""

# Test directory permissions for filesystem server
Write-Host "🔒 TESTING FILESYSTEM PERMISSIONS..." -ForegroundColor Yellow
Write-Host ""

$testDirs = @(
    "C:\Users",
    "C:\github\MCP", 
    "C:\temp"
)

foreach ($dir in $testDirs) {
    if (Test-Path $dir) {
        try {
            $access = Get-Acl $dir
            Write-Host "✅ Directory accessible: $dir" -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Directory access limited: $dir" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ Directory not found: $dir" -ForegroundColor Red
        if ($dir -eq "C:\temp") {
            Write-Host "   Creating temp directory..." -ForegroundColor Yellow
            try {
                New-Item -ItemType Directory -Path $dir -Force | Out-Null
                Write-Host "   ✅ Created: $dir" -ForegroundColor Green
            } catch {
                Write-Host "   ❌ Failed to create: $dir" -ForegroundColor Red
            }
        }
    }
}

Write-Host ""

# Summary
Write-Host "📊 TEST SUMMARY" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "🧠 Sequential Thinking MCP Server:" -ForegroundColor White
Write-Host "   • Test with: 'Can you walk me through solving this step-by-step'" -ForegroundColor Gray
Write-Host "   • Look for structured, numbered reasoning steps" -ForegroundColor Gray
Write-Host ""

Write-Host "📁 Filesystem MCP Server:" -ForegroundColor White
Write-Host "   • Test with: 'Can you list the contents of my Documents folder?'" -ForegroundColor Gray
Write-Host "   • Look for directory listings and file operations" -ForegroundColor Gray
Write-Host ""

Write-Host "🔄 Combined Usage:" -ForegroundColor White
Write-Host "   • Test with: 'Use sequential thinking to help me organize my files'" -ForegroundColor Gray
Write-Host "   • Should see both reasoning and file operations working together" -ForegroundColor Gray
Write-Host ""

Write-Host "⚠️ Remember: Restart Claude Desktop after configuration changes!" -ForegroundColor Yellow
Write-Host ""

Write-Host "⚡ MCP GRID TESTING COMPLETE ⚡" -ForegroundColor Cyan
