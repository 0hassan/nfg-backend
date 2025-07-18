# Git Flow Setup Script for Windows PowerShell

Write-Host "Setting up Git Flow..." -ForegroundColor Green

# Initialize git if not already initialized
if (-not (Test-Path ".git")) {
    git init
    Write-Host "Git repository initialized" -ForegroundColor Green
}

# Create main branches
try {
    git checkout -b main 2>$null
} catch {
    git checkout main
}

try {
    git checkout -b develop 2>$null
} catch {
    git checkout develop
}

try {
    git checkout -b staging 2>$null
} catch {
    git checkout staging
}

Write-Host "Main branches created: main, develop, staging" -ForegroundColor Green

# Create .gitignore if it doesn't exist
if (-not (Test-Path ".gitignore")) {
    $gitignoreContent = @'
# Dependencies
node_modules/
.pnpm-store/

# Production
dist/
build/

# Environment
.env
.env.local
.env.development
.env.test
.env.production
*.env

# Logs
logs/
*.log
npm-debug.log*
pnpm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/*
!.vscode/settings.json
!.vscode/extensions.json
!.vscode/launch.json
.idea/
*.swp
*.swo

# Testing
coverage/
.nyc_output/

# Temporary files
*.tmp
*.temp
.cache/

# Documentation
docs/.vitepress/dist/
docs/.vitepress/cache/

# Misc
*.pem
.vercel
.next
'@
    
    Set-Content -Path ".gitignore" -Value $gitignoreContent
    Write-Host ".gitignore created" -ForegroundColor Green
}

Write-Host "Branch protection rules should be configured on GitHub:" -ForegroundColor Yellow
Write-Host "  - main: Require pull request reviews, dismiss stale reviews"
Write-Host "  - develop: Require status checks to pass"
Write-Host "  - staging: Require up-to-date branches"

Write-Host "Git Flow setup complete!" -ForegroundColor Green
