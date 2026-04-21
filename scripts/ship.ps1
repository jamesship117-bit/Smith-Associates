param(
  [string]$Message = ""
)

$ErrorActionPreference = "Stop"

if (-not $Message -or $Message.Trim().Length -eq 0) {
  $Message = "chore: deploy update $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
  Write-Error "This command must be run inside a git repository."
  exit 1
}

git add -A

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
  Write-Host "No changes to commit."
  exit 0
}

git commit -m $Message
if ($LASTEXITCODE -ne 0) {
  Write-Error "Commit failed."
  exit 1
}

git push origin main
if ($LASTEXITCODE -ne 0) {
  Write-Error "Push failed."
  exit 1
}

Write-Host "Changes pushed to origin/main."
