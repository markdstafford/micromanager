# ADR 001: Tauri desktop framework

## Status

Accepted

## Context

We're building Episteme as a desktop-first application with plans to expand to web and mobile. The desktop app needs to:
- Run on macOS initially, Windows in Phase 2
- Feel native and performant
- Make external API calls (GitHub, AI providers)
- Execute local file operations (git, markdown processing)
- Embed a React-based UI

We need a framework that supports cross-platform development while allowing us to write the UI in React and handle local system operations. The choice affects bundle size, performance, development velocity, and our ability to iterate quickly.

Key constraints:
- Must produce native-feeling applications
- Must enable file system access and git operations
- Must support React frontend
- Application is being developed primarily through AI code generation

## Decision

We will use Tauri as our desktop framework.

Tauri provides:
- Dramatically smaller bundle size (~5-10MB vs ~150-200MB)
- Significantly better performance (faster startup, lower memory usage)
- More native feel by default
- Rust backend for system operations
- Cross-platform support for macOS, Windows, and Linux

While Tauri requires writing backend code in Rust, the performance benefits are substantial. The backend for Episteme is relatively thin (file operations, git CLI calls, HTTP requests to AI/GitHub APIs), making the Rust learning curve manageable. The framework choice is moderately reversible if needed (frontend React code is largely portable).

## Consequences

**Positive:**
- 90-95% smaller application bundle (~5-10MB vs ~150-200MB)
- Faster startup time (<1 second vs 1-3 seconds)
- 50-70% lower memory usage
- More native feel and performance
- Growing ecosystem with good core feature support
- Strong security model built-in

**Negative:**
- Backend must be written in Rust (steeper learning curve)
- Less mature ecosystem than Electron (3-4 years vs 10+ years)
- Fewer community examples and Stack Overflow answers
- AI may generate less idiomatic Rust code (less training data)
- Potential webview inconsistencies across platforms (different rendering engines per OS)

## Alternatives considered

**Option 1: Electron**

Electron bundles Chromium and Node.js to create cross-platform desktop apps with web technologies.

**Pros:**
- Mature ecosystem with extensive documentation and community support
- Node.js backend using JavaScript/TypeScript
- Rich plugin ecosystem for desktop features
- Widely used for desktop apps (VSCode is a well-known example)
- Fast development iteration with familiar tooling
- AI code generation works very well with JavaScript/TypeScript

**Cons:**
- Large bundle size (~150-200MB base application)
- Higher memory footprint (bundles Chromium engine)
- Slower startup time compared to native apps
- Can feel less "native" without careful tuning

**Why not chosen:** Bundle size and performance are important for a native-feeling desktop application. Tauri's significantly better performance characteristics outweigh the maturity advantages of Electron.
