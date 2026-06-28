# Rust Skills for Codex

## Installation

### Option 1: Codex Plugin (Full Features)

Install from GitHub:

```bash
codex plugin marketplace add Uber-Eins/rust-skills
codex plugin add rust-skills@Uber-Eins-Skills
```

Install from a local checkout:

```bash
git clone https://github.com/Uber-Eins/rust-skills.git
codex plugin marketplace add /path/to/rust-skills
codex plugin add rust-skills@Uber-Eins-Skills
```

The plugin manifest is `.codex-plugin/plugin.json`; the repository marketplace
entry is `.agents/plugins/marketplace.json`.

### Option 2: Skills-only

Copy only the skills when hooks and background agent manifests are not needed:

```bash
git clone https://github.com/Uber-Eins/rust-skills.git
mkdir -p ~/.codex/skills
cp -r rust-skills/skills/* ~/.codex/skills/
```

### Option 3: Project Instructions

Copy the main project instructions to another repository:

```bash
cp AGENTS.md /path/to/your/project/AGENTS.md
```

## What's Included

The Codex plugin provides Rust development assistance:

- **rust-router**: Master router for all Rust questions
- **rust-learner**: Rust version and crate information
- **coding-guidelines**: Code style and best practices
- **unsafe-checker**: Unsafe code review and FFI guidance
- **m01-m15**: Meta-question skills for ownership, concurrency, error handling, etc.
- **UserPromptSubmit hook**: Rust-only meta-cognition trigger
- **Agent manifests**: Background research and review agents under skill directories

## Usage

After installation, ask Codex about:

- Rust ownership and borrowing
- Error handling patterns
- Async/await and concurrency
- Code style and naming conventions
- Unsafe code review

To test hook execution without persisting hook trust during validation:

```bash
codex exec --dangerously-bypass-hook-trust "E0382 错误怎么解决"
```

## Requirements

- Rust 1.85+ (edition 2024 recommended)
- Cargo

## Default Project Settings

When creating Rust projects, use:

```toml
[package]
edition = "2024"
rust-version = "1.85"

[lints.rust]
unsafe_code = "warn"

[lints.clippy]
all = "warn"
pedantic = "warn"
```
