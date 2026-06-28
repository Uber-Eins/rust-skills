#!/usr/bin/env bash
set -euo pipefail

# Codex executes this hook after the UserPromptSubmit matcher has already
# selected a likely Rust prompt. Keep a second local guard so manual or broad
# hook execution stays silent for non-Rust tasks.
input="$(cat || true)"
prompt="${CODEX_USER_PROMPT:-${USER_PROMPT:-${RUST_SKILLS_USER_PROMPT:-}}}"
if [ -z "$prompt" ]; then
  prompt="$input"
fi

rust_signal='(Rust|cargo|rustc|crate|Cargo\.toml|\.rs\b|borrow checker|ownership|lifetime|moved value|cannot borrow|does not live long enough|trait bound|unsafe|FFI|tokio|serde|axum|actix|warp|clap|no_std|Rc<|Arc<|RefCell|Mutex|RwLock|Send|Sync|E0[0-9]{3,4}|所有权|借用|生命周期|编译错误|错误处理|智能指针|泛型|特征|宏|零成本|异步 Rust|Rust.*异步|并发 Rust|Rust.*并发|嵌入式 Rust|Rust.*嵌入式)'

if [ -n "$prompt" ] && ! printf '%s' "$prompt" | grep -Eiq "$rust_signal"; then
  exit 0
fi

cat <<'EOF'

=== RUST SKILLS AUTO META-COGNITION ===

This prompt matched the Rust Skills hook. Apply the Rust Skills routing flow
before answering.

1. Load rust-router first and use it to identify the entry layer.
2. For Layer 1 compiler or language errors, trace upward to design and domain
   constraints before proposing a fix.
3. If domain keywords are present, load both the mechanical skill and the
   matching domain skill.
4. For version, crate, docs, changelog, or ecosystem questions, use
   rust-learner and the background agent files under ./agents when present.

Mandatory response shape for non-trivial Rust questions:

### Reasoning Chain
+-- Layer 1: [specific compiler or language mechanism]
|   Problem: [what failed mechanically]
|       ^
+-- Layer 3: [domain context, if any]
|   Constraint: [why the domain changes the design choice]
|       v
+-- Layer 2: Design Choice
    Decision: [design pattern selected]

### Domain Constraints Analysis
- Reference the relevant domain skill when domain signals are present.

### Recommended Solution
- Provide the Rust fix that follows the design and domain constraints, not only
  the smallest compiler-error patch.

EOF
