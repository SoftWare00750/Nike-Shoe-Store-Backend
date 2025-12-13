# fix-public.ps1
# Script to fix Strapi public folder for Render deployment

Write-Host "Creating public folder structure..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "public\uploads" | Out-Null

Write-Host "Adding .gitkeep files..." -ForegroundColor Green
New-Item -ItemType File -Force -Path "public\.gitkeep" | Out-Null
New-Item -ItemType File -Force -Path "public\uploads\.gitkeep" | Out-Null

Write-Host "`nVerifying structure..." -ForegroundColor Yellow
Get-ChildItem -Path "public" -Recurse | Select-Object FullName

Write-Host "`nStaging files..." -ForegroundColor Green
git add public\.gitkeep
git add public\uploads\.gitkeep

Write-Host "`n✅ Done! Now run these commands:" -ForegroundColor Cyan
Write-Host "git commit -m 'Fix: Add public folder for Render'" -ForegroundColor White
Write-Host "git push origin main" -ForegroundColor White