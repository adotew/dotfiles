# Preferences

- Reply in English. Be concise: no preamble, no recap of what you just did.
- Prefer lean, readable, maintainable solutions. Simplest thing that works; no speculative abstractions.
- Match the existing code's style and idioms.
- Avoid unnecessary comments. Comment only to explain important or non-obvious details, not what the code already makes clear.

## Rust
- Idiomatic Rust; run `cargo fmt` and `cargo clippy` after changes.
- Avoid `unwrap()` outside tests; propagate errors with `?`.

## TypeScript
- Strict types; avoid `any`.
- Use the project's existing package manager, formatter, and linter.
