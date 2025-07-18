# Code Quality Tools Documentation

This document describes the code quality tools integrated into the NFG Backend project and how to use them effectively.

## Tools Overview

### 1. CommitLint

**Purpose**: Enforces conventional commit message format for better changelog generation and release management.

**Configuration**: `commitlint.config.js`

**Usage Examples**:

```bash
# ✅ Good commit messages
git commit -m "feat: Add user authentication endpoint"
git commit -m "fix: Resolve password validation issue"
git commit -m "docs: Update API documentation"

# ❌ Bad commit messages
git commit -m "update stuff"
git commit -m "Fixed bug"
git commit -m "WIP"
```

**Available Types**:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting changes
- `refactor`: Code restructuring
- `perf`: Performance improvements
- `test`: Test-related changes
- `chore`: Build/tool changes
- `ci`: CI configuration changes

### 2. ESLint Plugin SonarJS

**Purpose**: Detects code complexity, cognitive complexity, and maintainability issues.

**Key Rules**:

- `cognitive-complexity`: Limits function complexity (max 15)
- `no-duplicate-string`: Prevents string duplication (threshold 3)
- `prefer-immediate-return`: Suggests immediate returns
- `no-nested-template-literals`: Prevents complex template nesting

**Usage Examples**:

```typescript
// ❌ High cognitive complexity
function processUser(user: User) {
  if (user.isActive) {
    if (user.hasPermission) {
      if (user.email) {
        if (user.email.includes('@')) {
          // ... more nested logic
        }
      }
    }
  }
}

// ✅ Refactored with lower complexity
function processUser(user: User) {
  if (!user.isActive || !user.hasPermission || !user.email) {
    return false;
  }

  return user.email.includes('@');
}
```

### 3. ESLint Plugin Security

**Purpose**: Identifies potential security vulnerabilities in code.

**Key Rules**:

- `detect-object-injection`: Warns about potential object injection
- `detect-non-literal-regexp`: Flags dynamic RegExp creation
- `detect-unsafe-regex`: Identifies ReDoS vulnerabilities

**Usage Examples**:

```typescript
// ❌ Potential security issue
const userInput = req.body.key;
const data = someObject[userInput]; // Object injection risk

// ✅ Safer approach
const allowedKeys = ['name', 'email', 'age'];
const userInput = req.body.key;
if (allowedKeys.includes(userInput)) {
  const data = someObject[userInput];
}

// ❌ Unsafe regex
const pattern = new RegExp(userInput); // Potential ReDoS

// ✅ Safe regex
const safePattern = /^[a-zA-Z0-9]+$/;
if (safePattern.test(userInput)) {
  // Process input
}
```

### 4. ESLint Plugin Import

**Purpose**: Manages import/export statements and prevents circular dependencies.

**Key Rules**:

- `import/order`: Enforces import ordering
- `import/no-unresolved`: Ensures all imports resolve
- `import/no-cycle`: Prevents circular dependencies

**Usage Examples**:

```typescript
// ✅ Properly ordered imports
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';

import { User } from '../entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';

// ❌ Poor import order
import { CreateUserDto } from './dto/create-user.dto';
import { Injectable } from '@nestjs/common';
import { User } from '../entities/user.entity';
```

### 5. ESLint Plugin Jest

**Purpose**: Enforces Jest testing best practices and conventions.

**Key Rules**:

- `jest/expect-expect`: Ensures tests have assertions
- `jest/no-disabled-tests`: Warns about skipped tests
- `jest/prefer-to-be`: Suggests `toBe` over `toEqual` for primitives

**Usage Examples**:

```typescript
// ✅ Good test structure
describe('UserService', () => {
  it('should create a user', async () => {
    const userData = { name: 'John', email: 'john@example.com' };
    const result = await userService.create(userData);

    expect(result).toBeDefined();
    expect(result.name).toBe('John');
  });
});

// ❌ Missing assertions
describe('UserService', () => {
  it('should create a user', async () => {
    const userData = { name: 'John', email: 'john@example.com' };
    userService.create(userData); // No expectations!
  });
});
```

### 6. CSpell (Spell Checker)

**Purpose**: Checks spelling in code comments, strings, and documentation.

**Configuration**: `cspell.json`

**Note**: Markdown files (\*.md) are excluded from spell checking to avoid documentation formatting conflicts.

**Usage Examples**:

```typescript
// ✅ Correct spelling
/**
 * Authenticates user credentials
 * @param credentials User login information
 */
async function authenticate(credentials: LoginDto) {
  // Implementation
}

// ❌ Spelling errors
/**
 * Autenticates user credentails  // <- typos
 * @param creds User longin infomation  // <- typos
 */
```

## Running Quality Checks

### Individual Tools

```bash
# Run ESLint checks
pnpm run lint:check

# Run spell checking (TypeScript, JavaScript, JSON only)
pnpm run spell:check

# Run all spell checks (all file types except .md)
pnpm run spell:check-all

# Run comprehensive quality check
pnpm run quality:check
```

### Git Hooks

- **Pre-commit**: Runs linting, formatting, and spell checking on staged files (excludes .md files from spell check)
- **Commit-msg**: Validates commit message format using commitlint

### IDE Integration

Most tools integrate with VS Code through extensions:

- **ESLint Extension**: Real-time linting feedback
- **Code Spell Checker**: Highlights spelling errors
- **Prettier Extension**: Auto-formatting on save

## Configuration Files

| Tool       | Configuration File     | Purpose                   |
| ---------- | ---------------------- | ------------------------- |
| CommitLint | `commitlint.config.js` | Commit message rules      |
| ESLint     | `eslint.config.mjs`    | Linting rules and plugins |
| CSpell     | `cspell.json`          | Spell checking settings   |
| Prettier   | `.prettierrc`          | Code formatting rules     |
| Husky      | `.husky/`              | Git hooks configuration   |

## Best Practices

1. **Run checks before committing**: Use `pnpm run quality:check`
2. **Fix issues incrementally**: Don't disable rules without good reason
3. **Add project-specific words**: Update `cspell.json` for domain terms
4. **Review security warnings**: Take security plugin warnings seriously
5. **Maintain low complexity**: Refactor when cognitive complexity is high
6. **Write descriptive commits**: Follow conventional commit format

## Troubleshooting

### Common Issues

1. **Import resolution errors**: Ensure `tsconfig.json` paths are correctly configured
2. **Spell check false positives**: Add legitimate terms to `cspell.json` words array
3. **Complexity warnings**: Break down large functions into smaller, focused ones
4. **Security warnings**: Review and address or document why they're acceptable

### Disabling Rules

```typescript
// Disable specific rules when necessary (use sparingly)
// eslint-disable-next-line sonarjs/cognitive-complexity
function complexLegacyFunction() {
  // Complex but necessary logic
}

// Disable spell check for specific terms
// cspell:disable-next-line
const apiEndpoint = 'https://api.thirdpartyservice.com/v1/webhook';
```
