#Requires -Version 5.1

<#
.SYNOPSIS
    Setup Strapi backend for Render deployment
.DESCRIPTION
    Creates necessary folders and files for Strapi to deploy on Render
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

# Colors for output
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"
$Cyan = "Cyan"

Write-Host "`n=== Strapi Render Deployment Setup ===" -ForegroundColor $Cyan

# Step 1: Create directories
Write-Host "`n[1/6] Creating public folder structure..." -ForegroundColor $Green
try {
    New-Item -ItemType Directory -Force -Path "public\uploads" | Out-Null
    Write-Host "✅ Directories created" -ForegroundColor $Green
} catch {
    Write-Host "❌ Failed to create directories: $_" -ForegroundColor $Red
    exit 1
}

# Step 2: Create .gitkeep files
Write-Host "`n[2/6] Adding .gitkeep files..." -ForegroundColor $Green
try {
    New-Item -ItemType File -Force -Path "public\.gitkeep" | Out-Null
    New-Item -ItemType File -Force -Path "public\uploads\.gitkeep" | Out-Null
    Write-Host "✅ .gitkeep files created" -ForegroundColor $Green
} catch {
    Write-Host "❌ Failed to create .gitkeep files: $_" -ForegroundColor $Red
    exit 1
}

# Step 3: Verify structure
Write-Host "`n[3/6] Verifying structure..." -ForegroundColor $Yellow
$files = Get-ChildItem -Path "public" -Recurse -Force
$files | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor White }

# Step 4: Update .node-version
Write-Host "`n[4/6] Updating Node.js version..." -ForegroundColor $Green
try {
    "18.19.0" | Out-File -FilePath ".node-version" -Encoding ASCII -NoNewline
    Write-Host "✅ Node.js version set to 18.19.0" -ForegroundColor $Green
} catch {
    Write-Host "⚠️  Could not update .node-version: $_" -ForegroundColor $Yellow
}

# Step 5: Stage files
Write-Host "`n[5/6] Staging files for git..." -ForegroundColor $Green
try {
    git add public\.gitkeep public\uploads\.gitkeep .node-version 2>&1 | Out-Null
    Write-Host "✅ Files staged" -ForegroundColor $Green
} catch {
    Write-Host "❌ Git staging failed: $_" -ForegroundColor $Red
    exit 1
}

# Step 6: Show next steps
Write-Host "`n[6/6] Next steps:" -ForegroundColor $Cyan
Write-Host "Run these commands to complete setup:" -ForegroundColor $Yellow
Write-Host ""
Write-Host "  git commit -m 'Fix: Add public folder for Render deployment'" -ForegroundColor White
Write-Host "  git push origin main" -ForegroundColor White
Write-Host ""
Write-Host "Then update Render build command to:" -ForegroundColor $Yellow
Write-Host "  mkdir -p public/uploads && npm install && npm run build" -ForegroundColor White
Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor $Green