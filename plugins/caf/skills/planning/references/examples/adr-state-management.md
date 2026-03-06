# ADR 003: Zustand state management

## Status

Accepted

## Context

Episteme's React frontend needs to manage several types of state:
- Current document being edited/viewed
- Document list and repository structure
- AI chat history and active conversations
- User settings and preferences
- GitHub authentication state
- UI state (selected document, panel visibility, etc.)

The application has distinct areas (document list, editor pane, AI chat panel, settings) that need to share state. We need an approach that:
- Handles shared state across components
- Supports AI-driven updates to document content
- Scales as features are added
- Works well with AI code generation
- Doesn't over-complicate simple cases

Key constraints:
- Must work with React 18+
- Should be straightforward for AI to generate correct code
- Should handle both local component state and shared application state
- Performance matters for document editing experience

## Decision

We will use Zustand for state management.

Zustand provides simple, performant state management with minimal boilerplate. It's currently the fastest-growing state management solution with nearly equal adoption to Redux. The simple API works well with AI code generation, and its lightweight nature (1KB) fits well with our performance priorities. The library handles both local and shared state elegantly without provider wrappers or complex patterns.

## Consequences

**Positive:**
- Minimal boilerplate keeps code clean and maintainable
- Good performance with selective subscriptions
- No provider wrappers needed (simpler component tree)
- Works well with AI code generation (clear, simple patterns)
- Tiny bundle size (~1KB)
- Can create multiple stores for different domains
- Strong TypeScript support
- Growing community and adoption

**Negative:**
- Smaller ecosystem of middleware/tools compared to Redux
- Fewer examples and Stack Overflow answers than Redux
- No time-travel debugging like Redux DevTools

## Alternatives considered

**Option 1: Redux Toolkit**

Redux with modern "Redux Toolkit" API that reduces boilerplate. Still most downloaded at 23.9M weekly, mature and stable.

**Pros:**
- Most mature ecosystem
- Excellent DevTools for debugging
- AI knows Redux patterns very well
- Strong TypeScript support
- Proven at scale
- Lots of middleware and extensions

**Cons:**
- More boilerplate than alternatives (even with Redux Toolkit)
- Steeper learning curve
- More complex mental model (actions, reducers, slices)
- Heavier bundle size
- Can be overkill for simpler apps

**Why not chosen:** Zustand provides sufficient power with significantly less complexity and boilerplate. Redux's advantages (DevTools, ecosystem) don't outweigh its complexity for this project.

---

**Option 2: Jotai**

Jotai is an atomic state management library. 3.0M weekly downloads, growing strongly.

**Pros:**
- Atomic approach (fine-grained reactivity)
- Minimal boilerplate
- Good performance
- TypeScript-first design
- Growing community

**Cons:**
- Different mental model (atoms) vs traditional stores
- Smaller ecosystem than Zustand/Redux
- Less AI training data (newer library)

**Why not chosen:** While interesting, the atomic mental model adds conceptual overhead. Zustand's store-based approach is more straightforward and has broader adoption.

---

**Option 3: React Context + hooks**

Use React's built-in Context API with useState/useReducer hooks.

**Pros:**
- No additional dependencies
- Built into React
- AI knows it very well
- Simple for basic use cases

**Cons:**
- Performance issues (entire context re-renders on any change)
- Requires provider boilerplate
- Gets complex with multiple contexts
- Need to implement own optimization patterns

**Why not chosen:** Context's performance issues and lack of optimization patterns make it unsuitable for an app with frequent state updates (document editing, AI chat). Zustand's 1KB size is negligible, and its performance benefits are significant.
