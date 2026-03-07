#!/usr/bin/env bash
# Install modern Go development tools for professional Neovim setup
set -e

echo "🔧 Installing Go development tools..."

# Core debugging
echo "Installing delve debugger..."
go install github.com/go-delve/delve/cmd/dlv@latest

# Enhanced formatting (gofumpt)
echo "Installing gofumpt..."
go install mvdan.cc/gofumpt@latest

# Struct tag management
echo "Installing gomodifytags..."
go install github.com/fatih/gomodifytags@latest

# Test generation
echo "Installing gotests..."
go install github.com/cweill/gotests/gotests@latest

# Comprehensive linting
echo "Installing golangci-lint..."
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Vulnerability scanning
echo "Installing govulncheck..."
go install golang.org/x/vuln/cmd/govulncheck@latest

# Import management
echo "Installing goimports..."
go install golang.org/x/tools/cmd/goimports@latest

# Code generation helpers
echo "Installing impl..."
go install github.com/josharian/impl@latest

echo ""
echo "✅ All Go tools installed!"
echo ""
echo "To verify installation:"
echo "  dlv version"
echo "  gofumpt --version"
echo "  golangci-lint --version"
echo ""
echo "📚 Next steps:"
echo "1. Restart Neovim to load the new Go configuration"
echo "2. Open a .go file - plugins will auto-install on first use"
echo "3. Use <leader>g to see Go commands in which-key"
echo "4. Use <leader>t for testing commands"
echo "5. Set breakpoints with <leader>db and debug with <F5>"
