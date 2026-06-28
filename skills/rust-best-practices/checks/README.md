# checks — validate the rule index

This directory keeps the lightweight structural validator imported from the
upstream rule library. It checks the `../rules/*.md` files and verifies that
`../SKILL.md` links every rule exactly once.

## Run

```bash
# structural / link / index checks (no toolchain needed)
python3 checks/validate.py
```

## How it works

`validate.py` checks that each rule has a matching heading, summary, required
sections, valid rule links, and an index entry in `SKILL.md`.
