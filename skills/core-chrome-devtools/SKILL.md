---
name: core-chrome-devtools
description: "Internal support skill for chrome-devtools MCP workflows used by rust-learner, docs-researcher, rust-daily, and crate-researcher. Use only when browser automation or JavaScript-aware extraction is explicitly required."
user-invocable: false
disable-model-invocation: true
---

# Browser Automation with Chrome DevTools MCP

## Priority Note

For fetching Rust/crate information, use this priority order:
1. **rust-learner skill** - Orchestrates actionbook + browser-fetcher
2. **actionbook MCP** - Pre-computed selectors for known sites
3. **chrome-devtools MCP** - Browser automation and JS-aware extraction

Use chrome-devtools directly only when:
- actionbook has no pre-computed selectors for the target site
- The page depends on JavaScript or client-side navigation
- You need interactive browser testing/automation
- You need screenshots or form filling

## Quick start

```text
mcp__chrome_devtools__new_page({ url: "<url>" })
mcp__chrome_devtools__take_snapshot({})
mcp__chrome_devtools__click({ uid: "<uid>" })
mcp__chrome_devtools__fill_form({ elements: [{ uid: "<uid>", value: "text" }] })
mcp__chrome_devtools__evaluate_script({ function: "() => document.title" })
```

## Core workflow

1. Navigate with `mcp__chrome_devtools__new_page`
2. Inspect the page with `mcp__chrome_devtools__take_snapshot`
3. Interact using `click`, `fill_form`, `hover`, or `press_key`
4. Extract structured content with `mcp__chrome_devtools__evaluate_script`
5. Re-snapshot after navigation or significant DOM changes

## Tool patterns

### Navigation and page selection
```text
mcp__chrome_devtools__new_page({ url: "<url>" })
mcp__chrome_devtools__select_page({ pageId: <id>, bringToFront: true })
```

### Snapshot and extraction
```text
mcp__chrome_devtools__take_snapshot({})
mcp__chrome_devtools__evaluate_script({
  function: "() => document.querySelector('.docblock')?.innerText ?? ''"
})
```

### Interactions
```text
mcp__chrome_devtools__click({ uid: "<uid>" })
mcp__chrome_devtools__fill_form({
  elements: [
    { uid: "<email_uid>", value: "user@example.com" },
    { uid: "<password_uid>", value: "password123" }
  ]
})
mcp__chrome_devtools__press_key({ key: "Enter" })
mcp__chrome_devtools__hover({ uid: "<uid>" })
```

### Diagnostics
```text
mcp__chrome_devtools__take_screenshot({ fullPage: true })
mcp__chrome_devtools__list_console_messages({})
mcp__chrome_devtools__list_network_requests({})
mcp__chrome_devtools__get_network_request({ reqid: <id> })
```

Use diagnostics when selectors drift, pages fail to render, or API responses need inspection.

## Example: docs.rs extraction

```text
1. mcp__chrome_devtools__new_page({
     url: "https://docs.rs/tokio/latest/tokio/task/"
   })
2. mcp__chrome_devtools__evaluate_script({
     function: `() => ({
       title: document.title,
       docblock: document.querySelector('.docblock')?.innerText ?? '',
       signatures: Array.from(document.querySelectorAll('.item-decl'))
         .slice(0, 5)
         .map((el) => el.innerText)
     })`
   })
3. If extraction looks wrong, run mcp__chrome_devtools__take_snapshot({})
4. If the page is interactive, use click/fill_form/press_key and then re-run evaluate_script
```

## Notes

- Prefer `take_snapshot` over screenshots for normal page inspection.
- Use `evaluate_script` for text extraction; the tool returns JSON-serializable data.
- Pair actionbook selectors with `evaluate_script` when a site already has cached page structure.
