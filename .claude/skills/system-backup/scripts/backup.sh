#!/bin/bash
# System Backup Script
# Backs up Mac system state to the specified directory

set -e

# Check if directory argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <backup-directory>"
    exit 1
fi

BACKUP_DIR="$1"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "Starting system backup to: $BACKUP_DIR"

# 1. Mac defaults
echo "Backing up Mac defaults..."
defaults read > "$BACKUP_DIR/defaults.txt" 2>/dev/null || echo "Failed to read some defaults" >> "$BACKUP_DIR/defaults.txt"

# 2. Chrome Bookmarks
echo "Backing up Chrome bookmarks..."
CHROME_BOOKMARKS="$HOME/Library/Application Support/Google/Chrome/Default/Bookmarks"
if [ -f "$CHROME_BOOKMARKS" ]; then
    cp "$CHROME_BOOKMARKS" "$BACKUP_DIR/chrome_bookmarks.json"
else
    echo "Chrome bookmarks not found" > "$BACKUP_DIR/chrome_bookmarks.json"
fi

# 3. Applications list
echo "Backing up Applications list..."
ls -1 /Applications > "$BACKUP_DIR/applications.txt"

# 4. Homebrew packages
echo "Backing up Homebrew packages..."
if command -v brew &> /dev/null; then
    {
        echo "=== Formulae ==="
        brew list --formula
        echo ""
        echo "=== Casks ==="
        brew list --cask
    } > "$BACKUP_DIR/brew.txt"
else
    echo "Homebrew not installed" > "$BACKUP_DIR/brew.txt"
fi

# 5. Python pip packages
echo "Backing up pip packages..."
if command -v python3 &> /dev/null; then
    python3 -m pip list --format=freeze > "$BACKUP_DIR/pip.txt" 2>/dev/null || echo "pip not available" > "$BACKUP_DIR/pip.txt"
elif command -v python &> /dev/null; then
    python -m pip list --format=freeze > "$BACKUP_DIR/pip.txt" 2>/dev/null || echo "pip not available" > "$BACKUP_DIR/pip.txt"
else
    echo "Python not installed" > "$BACKUP_DIR/pip.txt"
fi

# 6. Node.js npm packages (global)
echo "Backing up npm global packages..."
if command -v npm &> /dev/null; then
    npm list -g --depth=0 > "$BACKUP_DIR/npm.txt" 2>/dev/null || echo "npm list failed" > "$BACKUP_DIR/npm.txt"
else
    echo "Node.js/npm not installed" > "$BACKUP_DIR/npm.txt"
fi

echo "Backup files created successfully."

# 7. Git commit and push if in a git repository
if git -C "$BACKUP_DIR" rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Git repository detected. Committing changes..."
    cd "$BACKUP_DIR"

    # Get current date
    CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

    # Add all backup files
    git add defaults.txt chrome_bookmarks.json applications.txt brew.txt pip.txt npm.txt

    # Check if there are changes to commit
    if git diff --cached --quiet; then
        echo "No changes to commit."
    else
        git commit -m "System backup: $CURRENT_DATE"
        echo "Pushing to origin/master..."
        git push origin master
        echo "Git push completed."
    fi
else
    echo "Not a git repository. Skipping git commit/push."
fi

echo "System backup completed!"
