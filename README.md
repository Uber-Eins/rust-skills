# Rust Skills

[中文](./README-zh.md) | [日本語](./README-ja.md)

> AI-powered Rust development assistant with meta-cognition framework

[![Version](https://img.shields.io/badge/version-2.2.0-green.svg)](https://github.com/Uber-Eins/rust-skills/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Codex](https://img.shields.io/badge/Codex-Plugin-blue)](https://openai.com/codex/)

## What is Rust Skills?

**Rust Skills** is a Codex plugin that transforms how AI assists with Rust development. Instead of giving surface-level answers, it traces through cognitive layers to provide **domain-correct architectural solutions**.

### The Problem

Traditional AI assistance for Rust:
```
User: "My trading system reports E0382"
AI: "Use .clone()"  ← Surface fix, ignores domain constraints
```

### The Solution

Rust Skills with meta-cognition:
```
User: "My trading system reports E0382"

AI (with Rust Skills):
├── Layer 1: E0382 = ownership error → Why is this data needed?
│       ↑
├── Layer 3: Trade records are immutable audit data → Should share, not copy
│       ↓
├── Layer 2: Use Arc<TradeRecord> as shared immutable value
│       ↓
└── Recommendation: Redesign as Arc<T>, not clone()
```

## Features

- **Meta-Cognition Framework**: Three-layer cognitive model (Domain → Design → Mechanics)
- **Real-time Information**: Fetch latest Rust versions and crate info via background agents
- **Dynamic Skills**: Auto-generate skills from your Cargo.toml dependencies
- **Domain Extensions**: FinTech, ML, Cloud-Native, IoT, Embedded, Web, CLI support
- **Coding Guidelines**: Complete Rust coding conventions and best practices
- **Best Practice Rules**: 265 idiomatic Rust rules from `leonardomso/rust-skills`

## Installation

Rust Skills supports two installation modes:

- **Codex Plugin Mode**: Full features including hooks, agents, MCP, and auto meta-cognition
- **Skills-only Mode**: Works with any coding agent that supports skills

---

### Skills-only Install (Recommended)

The simplest way to get started. Works with **any coding agent** that supports skills, including [Vercel's `add-skills`](https://github.com/nicepkg/add-skills), and others.

Skills now include **inline fallback logic** — when agent files are not available, skills execute directly using built-in tools (actionbook, agent-browser, WebFetch).

#### Option A: NPX (Easiest)

```bash
npx skills add Uber-Eins/rust-skills
```

#### Option B: CoWork CLI

Install via [CoWork](https://crates.io/crates/cowork), a Rust-based skills management tool:

```bash
# Install CoWork
cargo install cowork

# Method 1: Direct install
cowork install Uber-Eins/rust-skills

# Method 2: Config-based install (recommended for teams)
cowork config init                    # Create .cowork/Skills.toml
# Edit Skills.toml to add rust-skills (see below)
cowork config install                 # Install all configured skills
```

**Skills.toml configuration:**

```toml
[project]
name = "my-rust-project"

[skills.install]
rust-skills = "Uber-Eins/rust-skills"

[security]
trusted_authors = ["Uber-Eins"]
```

> CoWork (`co` for short) provides version management, dependency resolution, lock files, and security auditing. See [CoWork documentation](https://crates.io/crates/cowork) for more details.

#### Option C: Manual Copy

```bash
git clone https://github.com/Uber-Eins/rust-skills.git
cp -r rust-skills/skills/* ~/.codex/skills/
```

> **Note**: Skills-only mode does not include hooks, so meta-cognition won't trigger automatically. You can manually call `/rust-router` or specific skills. Background agents fall back to inline execution automatically.

---

### Codex Plugin Install (Full Features)

Use this mode for the complete experience with hooks, background agents, MCP, and auto meta-cognition triggering.

#### Option A: Git Marketplace

```bash
# Step 1: Add the marketplace from GitHub
codex plugin marketplace add Uber-Eins/rust-skills

# Step 2: Install the plugin
codex plugin add rust-skills@Uber-Eins-Skills
```

> **Note**: Step 1 only adds the marketplace source. Step 2 installs the rust-skills plugin with all features enabled.

#### Option B: Local Marketplace

```bash
# Clone the repository
git clone https://github.com/Uber-Eins/rust-skills.git

# Add the local marketplace and install the plugin
codex plugin marketplace add /path/to/rust-skills
codex plugin add rust-skills@Uber-Eins-Skills
```

---

### Feature Comparison

| Feature | Codex Plugin (Git) | Codex Plugin (Local) | Skills-only (NPX/CoWork/Manual) |
|---------|---------------------|----------------|--------------------------------|
| All 31 Skills | ✅ | ✅ | ✅ |
| Auto meta-cognition trigger | ✅ | ✅ | ❌ (manual invoke) |
| Hook-based routing | ✅ | ✅ | ❌ |
| Background agents | ✅ | ✅ | ✅ (inline fallback) |
| Easy updates | ✅ | ❌ | ✅ (NPX/CoWork) |
| Works with other agents | ❌ | ❌ | ✅ |

### Other Platforms

- **OpenCode**: See [.opencode/INSTALL.md](.opencode/INSTALL.md)
- **Codex**: See [.codex/INSTALL.md](.codex/INSTALL.md)

## Dependent Skills

Rust Skills relies on these external tools for full functionality:

| Tool | Description | GitHub |
|------|-------------|--------|
| **actionbook** | MCP server for website action manuals. Used by agents to fetch structured web content (Rust releases, crate info, documentation). | [actionbook/actionbook](https://github.com/actionbook/actionbook) |
| **agent-browser** | Browser automation tool for fetching real-time web data. Fallback when actionbook is unavailable. | [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) |

## Meta-Cognition Framework

### Core Concept

**Don't answer directly. Trace through cognitive layers first.**

```
Layer 3: Domain Constraints (WHY)
├── Domain rules determine design choices
└── Example: Financial systems require immutable, auditable data

Layer 2: Design Choices (WHAT)
├── Design patterns and architectural decisions
└── Example: Use Arc<T> for shared immutable data

Layer 1: Language Mechanics (HOW)
├── Rust language features and compiler rules
└── Example: E0382 is a symptom of ownership design issues
```

### Routing Rules

| User Signal | Entry Layer | Trace Direction | Primary Skill |
|-------------|-------------|-----------------|---------------|
| E0xxx errors | Layer 1 | Trace UP ↑ | m01-m07 |
| "How to design..." | Layer 2 | Bidirectional | m09-m15 |
| "[Domain] app development" | Layer 3 | Trace DOWN ↓ | domain-* |
| Performance issues | Layer 1→2 | Up then Down | m10-performance |

## Skills Overview

### Core Skills
- `rust-router` - Master router for all Rust questions (invoked first)
- `rust-learner` - Fetch latest Rust/crate version info
- `coding-guidelines` - Coding conventions lookup
- `rust-best-practices` - 265 detailed idiomatic Rust review rules

### Layer 1: Language Mechanics (m01-m07)

| Skill | Core Question | Triggers |
|-------|---------------|----------|
| m01-ownership | Who should own this data? | E0382, E0597, move, borrow |
| m02-resource | What ownership pattern fits? | Box, Rc, Arc, RefCell |
| m03-mutability | Why does this data need to change? | mut, Cell, E0596, E0499 |
| m04-zero-cost | Compile-time or runtime polymorphism? | generic, trait, E0277 |
| m05-type-driven | How can types prevent invalid states? | newtype, PhantomData |
| m06-error-handling | Expected failure or bug? | Result, Error, panic, ? |
| m07-concurrency | CPU-bound or I/O-bound? | async, Send, Sync, thread |

### Layer 2: Design Choices (m09-m15)

| Skill | Core Question | Triggers |
|-------|---------------|----------|
| m09-domain | What role does this concept play? | DDD, entity, value object |
| m10-performance | Where's the bottleneck? | benchmark, profiling |
| m11-ecosystem | Which crate fits this task? | crate selection, dependencies |
| m12-lifecycle | When to create, use, cleanup? | RAII, Drop, lazy init |
| m13-domain-error | Who handles this error? | retry, circuit breaker |
| m14-mental-model | How to think about this correctly? | learning Rust, why |
| m15-anti-pattern | Does this pattern hide design issues? | code smell, common mistakes |

### Layer 3: Domain Constraints (domain-*)

| Skill | Domain | Core Constraints |
|-------|--------|------------------|
| domain-fintech | FinTech | Audit trail, precision, consistency |
| domain-ml | Machine Learning | Memory efficiency, GPU acceleration |
| domain-cloud-native | Cloud Native | 12-Factor, observability, graceful shutdown |
| domain-iot | IoT | Offline-first, power management, security |
| domain-web | Web Services | Stateless, latency SLA, concurrency |
| domain-cli | CLI | UX, config precedence, exit codes |
| domain-embedded | Embedded | No heap, no_std, real-time |

## Commands

| Command | Description |
|---------|-------------|
| `/rust-features [version]` | Get Rust version features |
| `/crate-info <crate>` | Get crate information |
| `/docs <crate> [item]` | Get API documentation |
| `/sync-crate-skills` | Sync skills from Cargo.toml dependencies |
| `/update-crate-skill <crate>` | Update specific crate skill |
| `/clean-crate-skills` | Clean local crate skills |

## Dynamic Skills

Generate skills on-demand from your project dependencies:

```bash
# Enter your Rust project
cd my-rust-project

# Sync all dependencies
/sync-crate-skills

# Skills are created at ~/.codex/skills/{crate}/
```

### Features
- **On-demand generation**: Created from Cargo.toml dependencies
- **Local storage**: `~/.codex/skills/`
- **Version tracking**: Each skill records crate version
- **Workspace support**: Parses all workspace members

## How It Works

```
User Question
     │
     ▼
┌─────────────────────────────────────────┐
│           Hook Layer                     │
│  Rust-only matcher triggers meta-cognition│
└─────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────┐
│           rust-router                    │
│  Identify entry layer + domain           │
│  Decision: dual-skill loading            │
└─────────────────────────────────────────┘
     │
     ├──────────────┬──────────────┐
     ▼              ▼              ▼
┌──────────┐  ┌──────────┐  ┌──────────┐
│ Layer 1  │  │ Layer 2  │  │ Layer 3  │
│ m01-m07  │  │ m09-m15  │  │ domain-* │
└──────────┘  └──────────┘  └──────────┘
     │
     ▼
Domain-correct architectural solution
```

## Documentation

- [Architecture (中文)](./docs/architecture-zh.md)
- [Functional Overview (中文)](./docs/functional-overview-zh.md)
- [Hook Mechanism (中文)](./docs/hook-mechanism-zh.md)
- [Prompt Engineering (中文)](./docs/prompt-engineering-zh.md)
- [Meta-Cognition Example: E0382](./docs/meta-cognition-example-e0382.md)

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## Acknowledgments

- [@pinghe](https://github.com/pinghe) - `context: fork` support suggestion ([#4](https://github.com/Uber-Eins/rust-skills/issues/4))
- [@DoiiarX](https://github.com/DoiiarX) - OpenCode installation fix ([#6](https://github.com/Uber-Eins/rust-skills/issues/6))

## License

MIT License - see [LICENSE](LICENSE) for details.

## Links

- **GitHub**: https://github.com/Uber-Eins/rust-skills
- **Issues**: https://github.com/Uber-Eins/rust-skills/issues
