---
description: Generate comprehensive llms.txt from URLs using chrome-devtools MCP
argument-hint: <urls> [requirements]
---

# Create llms.txt from URLs

Use chrome-devtools MCP to access target URLs, extract content, and generate comprehensive llms.txt files.

Arguments: $ARGUMENTS
- First argument(s): urls (required) - one or more URLs, space-separated
- Last argument: requirements (optional) - additional requirements or instructions (if the last argument is not a URL)

---

## Tool Priority

1. **chrome-devtools MCP** (preferred) - Full browser automation with JavaScript support
2. **WebFetch** (fallback) - If chrome-devtools is unavailable

**DO NOT use:**
- Direct Fetch without user confirmation

---

## Instructions

### 1. Parse Arguments

From `$ARGUMENTS`, parse:
- Identify all URLs (starting with http:// or https://)
- Remaining content serves as additional requirements

### 2. Use chrome-devtools MCP

Use the page tools directly:

```text
# Step 1: Open the page
mcp__chrome_devtools__new_page({
  url: "https://docs.rs/{crate}/latest/{crate}/"
})

# Step 2: Extract structured content
mcp__chrome_devtools__evaluate_script({
  function: `() => ({
    docblocks: Array.from(document.querySelectorAll('.docblock'))
      .map((el) => el.innerText),
    modules: Array.from(document.querySelectorAll('.module-item'))
      .map((el) => el.innerText),
    declarations: Array.from(document.querySelectorAll('.item-decl'))
      .map((el) => el.innerText),
    examples: Array.from(document.querySelectorAll('pre.rust'))
      .map((el) => el.innerText),
    featureFlags: Array.from(document.querySelectorAll('.feature-flag'))
      .map((el) => el.innerText),
    reexports: document.querySelector('#reexports')?.innerText ?? ""
  })`
})
```

**Common selectors for docs.rs:**

| Selector | Content |
|----------|---------|
| `.docblock` | Main documentation text |
| `.module-item` | Module/item list |
| `.item-decl` | Function/struct declarations |
| `pre.rust` | Code examples |
| `.feature-flag` | Feature flags |
| `#reexports` | Re-exports section |

**For multiple pages**, repeat `new_page`/`evaluate_script` for each submodule.

### 3. Content Extraction Strategy

For Rust crate documentation (docs.rs):

```
1. Main crate page → Overview, re-exports, modules list
2. Each major module → Public items, examples
3. Important types → Methods, trait implementations
4. Examples section → Complete runnable code
```

**Extraction focus**:
- Core concepts and principles
- API function signatures and parameter descriptions
- Code examples (complete and runnable)
- Configuration options and best practices
- Common patterns and use cases
- Feature flags and cargo features

### 4. Generate llms.txt

Consolidate all content and generate in the following format:

````markdown
# {Crate Name}

> {One-line description from crate docs}

**Version:** {version} | **docs.rs:** {url}

---

## Overview

{Detailed explanation of core concepts from crate-level docs}

## Modules

### {module_name}

{Module description}

#### Key Types

| Type | Description |
|------|-------------|
| `TypeName` | Brief description |

#### Key Functions

```rust
// Function signature with doc comment
pub fn function_name(param: Type) -> ReturnType
```

### Code Examples

```rust
// Complete code example from docs
use crate_name::...;

fn main() {
    // Example code
}
```

---

## Feature Flags

| Feature | Description | Default |
|---------|-------------|---------|
| `feature_name` | What it enables | yes/no |

---

## Common Patterns

### Pattern 1: {Name}
```rust
// Pattern code
```

### Pattern 2: {Name}
```rust
// Pattern code
```
````

### 5. Save Output

```bash
# Generate timestamp
timestamp=$(date +%Y%m%d%H%M)

# Determine crate name from URL
# e.g., https://docs.rs/tokio/latest/tokio/ → tokio

# Save location
~/tmp/${timestamp}-{crate_name}-llms.txt
```

Inform the user of the file path after output is complete.

---

## Fallback: WebFetch

If chrome-devtools is not available:

```
1. Use WebFetch to get main page content
2. Parse the response for key sections
3. May need multiple WebFetch calls for subpages
4. Inform user that content may be incomplete
```

---

## Quality Requirements

- [ ] Comprehensive content: Include actual API descriptions and code examples
- [ ] Clear sources: Mark source URL for each section
- [ ] Complete structure: Maintain the hierarchy of the original documentation
- [ ] Usable code: Example code should be complete and runnable
- [ ] Consistent format: Use consistent Markdown formatting
- [ ] Feature flags: Document all cargo features

---

## Workflow Integration

This command is the first step in the Skills creation workflow:

1. **create-llms-for-skills** (this command) → Generate llms.txt
2. **create-skills-via-llms** → Create skills based on llms.txt

---

## Example Usage

```bash
# Generate llms.txt for tokio
/create-llms-for-skills https://docs.rs/tokio/latest/tokio/

# Generate for multiple URLs
/create-llms-for-skills https://docs.rs/serde/latest/serde/ https://serde.rs/

# With additional requirements
/create-llms-for-skills https://docs.rs/axum/latest/axum/ "Focus on routing and extractors"
```
