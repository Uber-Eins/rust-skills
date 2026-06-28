#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up Rust Skills for Codex..."
echo ""
echo "Marketplace:"
echo "  $repo_root/.agents/plugins/marketplace.json"
echo ""
echo "Run:"
echo "  codex plugin marketplace add \"$repo_root\""
echo "  codex plugin add rust-skills@Uber-Eins-Skills"
echo ""
echo "For one-shot hook validation without persisted hook trust:"
echo "  codex exec --dangerously-bypass-hook-trust \"E0382 错误怎么解决\""
