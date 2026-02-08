#!/bin/bash

# Social Publisher Installation Script
# Version: v1.0
# Date: 2026-02-08

set -e  # Exit on error

echo "📦 Social Publisher Installation"
echo "=============================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if script is run from project root
if [ ! -f "README.md" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

print_success "Project directory verified"

# Check Python version
echo ""
echo "🔍 Checking Python version..."
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed"
    echo "   Please install Python 3.7 or higher"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | awk '{print $2}')
print_success "Python $PYTHON_VERSION found"

# Check if pip is available
if ! command -v pip3 &> /dev/null; then
    print_warning "pip3 not found, attempting to install dependencies without it"
else
    print_success "pip3 found"
fi

# Install dependencies
echo ""
echo "📦 Installing Python dependencies..."
if command -v pip3 &> /dev/null; then
    pip3 install requests requests-oauthlib || {
        print_warning "Failed to install dependencies via pip3"
        echo "   Please install manually: pip3 install requests requests-oauthlib"
    }
else
    print_warning "Skipping Python package installation"
fi

# Create bin directory if it doesn't exist
BIN_DIR="$HOME/bin"
if [ ! -d "$BIN_DIR" ]; then
    echo ""
    echo "📁 Creating bin directory: $BIN_DIR"
    mkdir -p "$BIN_DIR"
    print_success "Directory created"
else
    print_success "bin directory exists"
fi

# Create symlinks
echo ""
echo "🔗 Creating command symlinks..."

# Get project root
PROJECT_ROOT=$(pwd)

# Remove existing symlinks if they exist
if [ -L "$BIN_DIR/ts" ]; then
    echo "   Removing existing ts symlink"
    rm "$BIN_DIR/ts"
fi

if [ -L "$BIN_DIR/social" ]; then
    echo "   Removing existing social symlink"
    rm "$BIN_DIR/social"
fi

# Create new symlinks
ln -sf "$PROJECT_ROOT/src/tsearch" "$BIN_DIR/ts"
print_success "ts → $PROJECT_ROOT/src/tsearch"

ln -sf "$PROJECT_ROOT/src/social" "$BIN_DIR/social"
print_success "social → $PROJECT_ROOT/src/social"

# Set executable permissions
echo ""
echo "🔐 Setting executable permissions..."
chmod +x "$PROJECT_ROOT/src/tsearch"
chmod +x "$PROJECT_ROOT/src/social"
print_success "Permissions set"

# Check if bin directory is in PATH
echo ""
echo "🔍 Checking PATH configuration..."
if [[ ":$PATH:" == *":$BIN_DIR:"* ]]; then
    print_success "$BIN_DIR is in PATH"
else
    print_warning "$BIN_DIR is not in PATH"
    echo ""
    echo "💡 Add this to your ~/.zshrc or ~/.bashrc:"
    echo ""
    echo "   export PATH=\"\$HOME/bin:\$PATH\""
    echo ""
    echo "   Then run: source ~/.zshrc  (or source ~/.bashrc)"
fi

# Verify installation
echo ""
echo "🧪 Verifying installation..."

if command -v ts &> /dev/null; then
    print_success "ts command is available"
    TS_VERSION=$(ts --version 2>/dev/null || echo "v1.0.0")
    echo "   Version: $TS_VERSION"
else
    print_error "ts command is not available"
    echo "   💡 Make sure $BIN_DIR is in your PATH"
fi

if command -v social &> /dev/null; then
    print_success "social command is available"
else
    print_error "social command is not available"
    echo "   💡 Make sure $BIN_DIR is in your PATH"
fi

# Check environment variables
echo ""
echo "🔑 Checking environment variables..."

ENV_FILE="$HOME/.claude/credentials/.env"

if [ -f "$ENV_FILE" ]; then
    if grep -q "TWITTER_API_KEY" "$ENV_FILE"; then
        print_success "Twitter API configuration found"
    else
        print_warning "Twitter API configuration not found in $ENV_FILE"
        echo ""
        echo "💡 Please configure your Twitter API credentials:"
        echo ""
        echo "   1. Get credentials from: https://developer.twitter.com/"
        echo "   2. Copy .env.example to $ENV_FILE"
        echo "   3. Fill in your API keys"
    fi
else
    print_warning "Environment file not found: $ENV_FILE"
    echo ""
    echo "💡 Setting up environment file..."
    mkdir -p "$HOME/.claude/credentials"

    if [ -f ".env.example" ]; then
        cp .env.example "$ENV_FILE"
        print_success "Environment template copied to $ENV_FILE"
        echo ""
        echo "⚠️  Please edit $ENV_FILE and add your Twitter API credentials"
    else
        print_error ".env.example not found"
    fi
fi

# Check Claude Code Skill
echo ""
echo "🎓 Checking Claude Code Skill..."

SKILL_DIR="$HOME/.claude/skills/social-publisher"

if [ -f "docs/SKILL.md" ]; then
    mkdir -p "$SKILL_DIR"
    cp docs/SKILL.md "$SKILL_DIR/SKILL.md"
    print_success "Claude Code Skill installed to $SKILL_DIR"
else
    print_warning "Claude Code Skill file not found (docs/SKILL.md)"
fi

# Installation complete
echo ""
echo "=============================="
echo -e "${GREEN}🎉 Installation Complete!${NC}"
echo ""
echo "📝 Quick Start:"
echo ""
echo "   # View help"
echo "   ts --help"
echo "   social --help"
echo ""
echo "   # List platforms"
echo "   social config list"
echo ""
echo "   # Publish a tweet"
echo "   ts post \"Hello from Social Publisher!\""
echo ""
echo "📚 Documentation:"
echo "   README: $PROJECT_ROOT/README.md"
echo "   Examples: $PROJECT_ROOT/examples/"
echo ""
echo "💬 In Claude Code, try:"
echo "   发推：AI时代需要新的思维模式"
echo ""
