#!/bin/bash

# Git helper functions

# Create feature branch
create-feature() {
    if [ -z "$1" ]; then
        echo "Usage: create-feature <feature-name>"
        return 1
    fi
    git checkout develop
    git pull origin develop
    git checkout -b feature/$1
}

# Create bugfix branch
create-bugfix() {
    if [ -z "$1" ]; then
        echo "Usage: create-bugfix <bugfix-name>"
        return 1
    fi
    git checkout develop
    git pull origin develop
    git checkout -b bugfix/$1
}

# Create hotfix branch
create-hotfix() {
    if [ -z "$1" ]; then
        echo "Usage: create-hotfix <hotfix-name>"
        return 1
    fi
    git checkout main
    git pull origin main
    git checkout -b hotfix/$1
}

# Finish feature
finish-feature() {
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [[ ! "$BRANCH" =~ ^feature/.* ]]; then
        echo "Not on a feature branch"
        return 1
    fi
    git checkout develop
    git merge --no-ff $BRANCH
    git branch -d $BRANCH
}

# Add aliases
alias gf='create-feature'
alias gb='create-bugfix'
alias gh='create-hotfix'
alias gff='finish-feature'
