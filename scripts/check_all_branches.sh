#!/bin/bash

# Default root directory is current directory
ROOT_DIR="${1:-.}"

# Function to check if branches in the repo need pushing
check_repo() {
    local repo_dir="$1"
    echo "Checking repo: $repo_dir"
    
    cd "$HOME/$repo_dir" || return

    # Ensure it's a Git repo
    if [ ! -d .git ]; then
        echo "  ⚠️  Not a git repository"
        return
    fi

    # Fetch latest info from remote
    git fetch --all --quiet

    # Get all local branches
    branches=$(git for-each-ref --format='%(refname:short)' refs/heads/)

    if [ -z "$branches" ]; then
        echo "  ⚠️  No local branches found"
        return
    fi

    for branch in $branches; do
        echo "  Branch: $branch"
        
        # Check if the branch tracks a remote
        tracking_branch=$(git for-each-ref --format='%(upstream:short)' refs/heads/"$branch")

        if [ -z "$tracking_branch" ]; then
            echo "    ⚠️  No remote tracking branch set"
            continue
        fi

        # Count how many commits this branch is ahead/behind
        ahead=$(git rev-list --count "$tracking_branch"..refs/heads/"$branch" 2>/dev/null)
        behind=$(git rev-list --count refs/heads/"$branch".."$tracking_branch" 2>/dev/null)

        if [ "$ahead" -gt 0 ]; then
            echo "    🚀 Ahead of $tracking_branch by $ahead commits (needs push)"
        else
            echo "    ✅ Up to date with $tracking_branch"
        fi
    done
}

export -f check_repo

# Find all Git repos and check them
find "$ROOT_DIR" -type d -name ".git" | while read -r gitdir; do
    repo_dir=$(dirname "$gitdir")
    check_repo "$repo_dir"
done

