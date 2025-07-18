# Git Workflow Guide

## Branch Structure

```text
main (production)
├── hotfix/critical-bug
├── staging (pre-production)
└── develop (integration)
    ├── feature/new-feature
    ├── bugfix/fix-issue
    └── chore/update-deps
```

## Branch Naming Convention

- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Critical production fixes
- `chore/*` - Maintenance tasks
- `docs/*` - Documentation updates

## Workflow

### 1. Starting New Work

```bash
# For new feature
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name

# For bug fix
git checkout develop
git pull origin develop
git checkout -b bugfix/your-bugfix-name

# For hotfix
git checkout main
git pull origin main
git checkout -b hotfix/your-hotfix-name
```

### 2. Committing Changes

Follow conventional commits format:

```bash
git add .
git commit -m "feat(scope): add new feature"
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Tests
- `build`: Build system
- `ci`: CI/CD
- `chore`: Maintenance

### 3. Creating Pull Request

1. Push your branch:

```bash
git push origin feature/your-feature-name
```

1. Create PR on GitHub
1. Fill out PR template
1. Request reviews
1. Address feedback

### 4. Merging

- Feature/bugfix → develop: After approval
- Develop → staging: For testing
- Staging → main: For production release

### 5. Releases

1. Create release branch from main
2. Update version in package.json
3. Create tag:

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## Protected Branches

### Main Branch

- No direct pushes
- Require PR reviews (2)
- Dismiss stale reviews
- Require status checks
- Include administrators

### Develop Branch

- No direct pushes
- Require PR reviews (1)
- Require status checks
- Require branches up to date

### Staging Branch

- Require status checks
- Require branches up to date

## Git Helper Scripts

Use the helper scripts in `scripts/git-helpers.sh`:

```bash
# Source the helpers
source scripts/git-helpers.sh

# Create feature branch
gf my-new-feature

# Create bugfix branch
gb fix-critical-issue

# Create hotfix branch
gh hotfix-security-patch

# Finish feature (merge to develop)
gff
```

## CI/CD Pipeline

The project includes automated workflows:

1. **Continuous Integration** (`.github/workflows/ci.yml`)
   - Runs on push/PR to main, develop, staging
   - Linting, testing, building
   - Security scanning

2. **Deployment** (`.github/workflows/deploy.yml`)
   - Staging deployment from staging branch
   - Production deployment from main branch

3. **Release** (`.github/workflows/release.yml`)
   - Automatic releases on version tags

4. **Dependabot** (`.github/dependabot.yml`)
   - Weekly dependency updates
   - Automatic PR creation

## Testing the Workflow

1. Run the setup script:

```bash
chmod +x scripts/setup-git-flow.sh
./scripts/setup-git-flow.sh
```

1. Test creating a feature branch:

```bash
git checkout develop
git checkout -b feature/test-feature
git add .
git commit -m "feat(git): add comprehensive git workflow"
git push origin feature/test-feature
```

## Environment Variables for CI/CD

Set these secrets in your GitHub repository:

- `DOCKER_REGISTRY`: Docker registry URL
- `DOCKER_USERNAME`: Docker registry username
- `DOCKER_PASSWORD`: Docker registry password
- `SNYK_TOKEN`: Snyk security scanning token

## Best Practices

1. **Always create branches from the appropriate base:**
   - Features from `develop`
   - Hotfixes from `main`

2. **Use descriptive commit messages:**
   - Follow conventional commits
   - Include scope when relevant

3. **Keep PRs focused:**
   - One feature/fix per PR
   - Review your own code before requesting reviews

4. **Test locally before pushing:**
   - Run tests: `pnpm test`
   - Run linting: `pnpm run lint:check`
   - Build successfully: `pnpm run build`

5. **Update documentation:**
   - Include relevant docs updates
   - Update README if needed
