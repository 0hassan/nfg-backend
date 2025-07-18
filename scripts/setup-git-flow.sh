#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up Git Flow...${NC}"

# Initialize git if not already initialized
if [ ! -d .git ]; then
    git init
    echo -e "${GREEN}Git repository initialized${NC}"
fi

# Create main branches
git checkout -b main 2>/dev/null || git checkout main
git checkout -b develop 2>/dev/null || git checkout develop
git checkout -b staging 2>/dev/null || git checkout staging

echo -e "${GREEN}Main branches created: main, develop, staging${NC}"

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    cat > .gitignore << 'EOL'
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
EOL
    echo -e "${GREEN}.gitignore created${NC}"
fi

echo -e "${YELLOW}Branch protection rules should be configured on GitHub:${NC}"
echo "  - main: Require pull request reviews, dismiss stale reviews"
echo "  - develop: Require status checks to pass"
echo "  - staging: Require up-to-date branches"

echo -e "${GREEN}Git Flow setup complete!${NC}"
