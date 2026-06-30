---
name: rust-daily
description: |
  CRITICAL: Use for Rust news and daily/weekly/monthly reports. Triggers on:
  rust news, rust daily, rust weekly, TWIR, rust blog,
  Rust 日报, Rust 周报, Rust 新闻, Rust 动态
argument-hint: "[today|week|month]"
context: fork
agent: Explore
---

# Rust Daily Report

> **Version:** 2.1.0 | **Last Updated:** 2025-01-27

Fetch Rust community updates, filtered by time range.

## Data Sources

| Category | Sources |
|----------|---------|
| Ecosystem | Reddit r/rust, This Week in Rust |
| Official | blog.rust-lang.org, Inside Rust |
| Foundation | rustfoundation.org (news, blog, events) |

## Parameters

- `time_range`: day | week | month (default: week)
- `category`: all | ecosystem | official | foundation

## Execution Mode Detection

**CRITICAL: Check agent file availability first to determine execution mode.**

Try to read: `../../agents/rust-daily-reporter.md`

---

## Agent Mode (Plugin Install)

**When `../../agents/rust-daily-reporter.md` exists:**

### Workflow

```
1. Read: ../../agents/rust-daily-reporter.md
2. Task(subagent_type: "general-purpose", run_in_background: false, prompt: <agent content>)
3. Wait for result
4. Format and present to user
```

---

## Inline Mode (Skills-only Install)

**When agent file is NOT available, execute each source directly:**

### 1. Reddit r/rust

```text
1. mcp__chrome_devtools__new_page({ url: "https://www.reddit.com/r/rust/hot/" })
2. mcp__chrome_devtools__evaluate_script({
     function: `() => Array.from(
       document.querySelectorAll('[data-testid="post-container"]')
     ).slice(0, 10).map((el) => el.innerText)`
   })
```

**Or with WebFetch fallback:**
```
WebFetch("https://www.reddit.com/r/rust/hot/", "Extract top 10 posts with scores and titles")
```

**Parse output into:**
| Score | Title | Link |
|-------|-------|------|

### 2. This Week in Rust

```text
# Check actionbook first
mcp__actionbook__search_actions("this week in rust")
mcp__actionbook__get_action_by_id(<action_id>)

# Then fetch
mcp__chrome_devtools__new_page({ url: "https://this-week-in-rust.org/" })
mcp__chrome_devtools__evaluate_script({
  function: "() => document.querySelector('<selector_from_actionbook>')?.innerText ?? ''"
})
```

**Parse output into:**
- Issue #{number} ({date}): highlights

### 3. Rust Blog (Official)

```text
1. mcp__chrome_devtools__new_page({ url: "https://blog.rust-lang.org/" })
2. mcp__chrome_devtools__evaluate_script({
     function: `() => Array.from(document.querySelectorAll('article'))
       .slice(0, 5)
       .map((el) => el.innerText)`
   })
```

**Or with WebFetch fallback:**
```
WebFetch("https://blog.rust-lang.org/", "Extract latest 5 blog posts with dates and titles")
```

**Parse output into:**
| Date | Title | Summary |
|------|-------|---------|

### 4. Inside Rust

```text
1. mcp__chrome_devtools__new_page({
     url: "https://blog.rust-lang.org/inside-rust/"
   })
2. mcp__chrome_devtools__evaluate_script({
     function: `() => Array.from(document.querySelectorAll('article'))
       .slice(0, 3)
       .map((el) => el.innerText)`
   })
```

**Or with WebFetch fallback:**
```
WebFetch("https://blog.rust-lang.org/inside-rust/", "Extract latest 3 posts with dates and titles")
```

### 5. Rust Foundation

```text
# News
mcp__chrome_devtools__new_page({
  url: "https://rustfoundation.org/media/category/news/"
})
mcp__chrome_devtools__evaluate_script({
  function: `() => Array.from(document.querySelectorAll('article'))
    .slice(0, 3)
    .map((el) => el.innerText)`
})

# Blog
mcp__chrome_devtools__new_page({
  url: "https://rustfoundation.org/media/category/blog/"
})
mcp__chrome_devtools__evaluate_script({
  function: `() => Array.from(document.querySelectorAll('article'))
    .slice(0, 3)
    .map((el) => el.innerText)`
})

# Events
mcp__chrome_devtools__new_page({ url: "https://rustfoundation.org/events/" })
mcp__chrome_devtools__evaluate_script({
  function: `() => Array.from(document.querySelectorAll('article'))
    .slice(0, 3)
    .map((el) => el.innerText)`
})
```

### Time Filtering

After fetching all sources, filter by time range:

| Range | Filter |
|-------|--------|
| day | Last 24 hours |
| week | Last 7 days |
| month | Last 30 days |

### Combining Results

After fetching all sources, combine into the output format below.

---

## Tool Chain Priority

Both modes use the same tool chain order:

1. **actionbook MCP** - Check for cached/pre-fetched content first
   ```
   mcp__actionbook__search_actions("rust news {date}")
   mcp__actionbook__search_actions("this week in rust")
   mcp__actionbook__search_actions("rust blog")
   ```

2. **chrome-devtools MCP** - For dynamic web content
   ```text
   mcp__chrome_devtools__new_page({ url: "<url>" })
   mcp__chrome_devtools__evaluate_script({
     function: "() => document.querySelector('<selector>')?.innerText ?? ''"
   })
   ```

3. **WebFetch** - Fallback if chrome-devtools is unavailable

| Source | Primary Tool | Fallback |
|--------|--------------|----------|
| Reddit | chrome-devtools | WebFetch |
| TWIR | actionbook → chrome-devtools | WebFetch |
| Rust Blog | actionbook → WebFetch | - |
| Foundation | actionbook → WebFetch | - |

**DO NOT use:**
- Skip chrome-devtools when the page needs JavaScript execution
- WebSearch for fetching news pages

---

## Output Format

```markdown
# Rust {Weekly|Daily|Monthly} Report

**Time Range:** {start} - {end}

## Ecosystem

### Reddit r/rust
| Score | Title | Link |
|-------|-------|------|
| {score} | {title} | [link]({url}) |

### This Week in Rust
- Issue #{number} ({date}): highlights

## Official
| Date | Title | Summary |
|------|-------|---------|
| {date} | {title} | {summary} |

## Foundation
| Date | Title | Summary |
|------|-------|---------|
| {date} | {title} | {summary} |
```

---

## Validation

- Each source should have at least 1 result, otherwise mark "No updates"
- On fetch failure, retry with alternative tool
- Report reason if all tools fail for a source

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| Agent file not found | Skills-only install | Use inline mode |
| chrome-devtools unavailable | MCP server not installed | Use WebFetch |
| Site timeout | Network issues | Retry once, then skip source |
| Empty results | Selector mismatch | Report and use fallback |
