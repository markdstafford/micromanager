# Writing ADRs

> **This is a process document.** Follow these steps in order.
> Refer to the planning skill's SKILL.md for shared concepts
> (prerequisites, checkpoints, wiki management).

This stage guides the creation of Architectural Decision Records (ADRs) to document important technical, domain, and data architecture decisions.

## When to create ADRs

- **Technical architecture** — selecting technologies, frameworks, or architectural patterns
- **Domain model** — defining core domain concepts, entities, and relationships
- **Data architecture** — establishing database schemas, storage patterns, data flow
- **System-wide conventions** — coding standards, naming conventions, structural patterns
- **Prerequisite for feature** — a feature requires a foundational decision that hasn't been made
- **User asks explicitly** — user requests an ADR or asks to document a decision

**Bias toward creating ADRs.** When in doubt, err on the side of documenting a decision.

## Output

Individual ADR files in `.eng-docs/adrs/` with naming pattern `adr-NNN-title.md`.

Each ADR contains: Title, Status, Context, Decision, Consequences (positive and negative), Alternatives considered.

## Process

### 1. Identify the decision

- State the decision area clearly
- Determine the category: technical, domain, or data architecture
- Assign the next available ADR number

### 2. Gather context

**You lead (70% you, 30% human).**

- Research the codebase to understand current state
- Identify constraints (technical, business, team)
- Ask human clarifying questions about: business requirements, non-functional requirements, team constraints, timeline
- Draft the Context section explaining what decision needs to be made, why, and what constraints exist

**CHECKPOINT**: Get human approval on context before proceeding

### 3. Propose alternatives

**You lead (70% you, 30% human).**

- Research 2-4 viable alternatives
- For each alternative, describe: what it is, 3-5 pros, 3-5 cons, when it's appropriate
- Present alternatives neutrally
- Highlight key trade-offs
- Ask human if they want to add or modify alternatives

**CHECKPOINT**: Get human approval on alternatives list before proceeding

### 4. Get human decision

**Human leads (80% human, 20% you).**

- Ask human which alternative they choose
- If uncertain, help by asking clarifying questions, explaining trade-offs, recommending an option
- **Critical**: Human makes the final decision, not you
- Document their choice in the Decision section

### 5. Document consequences

**Collaborative (50/50).**

- Draft positive consequences (3-5 benefits)
- Draft negative consequences (3-5 costs, risks, limitations)
- Be honest about negatives — every decision has trade-offs
- Ask human to review and add consequences you missed

**CHECKPOINT**: Get human approval on final ADR before writing to file

### 6. Update related artifacts

- Write ADR file to `.eng-docs/adrs/adr-NNN-title.md`
- Update wiki artifacts based on decision type (see planning skill's wiki management)
- Reference the ADR in app.md or feature-*.md if applicable

## Status management

- New ADRs start as "Proposed"
- Change to "Accepted" after human approval
- Mark as "Superseded by ADR-XXX" if replaced
- Mark as "Deprecated" if no longer relevant

## Decisions that warrant ADRs

| Decision type | Recommendation |
|---|---|
| Core domain concepts | Strongly recommended |
| Database schema approach | Strongly recommended |
| API style (REST/GraphQL/gRPC/tRPC) | Strongly recommended |
| Frontend framework | Strongly recommended |
| Backend framework | Strongly recommended |
| Build tool | Strongly recommended |
| State management | Strongly recommended |
| Styling approach | Strongly recommended |
| ORM/query builder | Strongly recommended |
| Testing frameworks | Strongly recommended |
| Authentication/authorization pattern | Strongly recommended |
| Architectural pattern (monolith/microservices) | Strongly recommended |
| System-wide convention | Suggested |
| Feature-specific approach | Optional (document in tech spec instead) |
| Implementation detail | No (belongs in code) |

## Key guidelines

- ADRs document decisions, not requirements or specifications
- Focus on "why" we chose this approach, not just "what"
- Domain decisions (entities, relationships, hierarchies) are just as important as technical decisions
- Be a partner, not a sycophant — identify weaknesses in the human's preferred option
- Challenge decisions constructively

For templates and examples, see:
- `references/templates/adr.md` — template for ADR files
- `references/examples/adr-desktop-framework.md` — example technical ADR
- `references/examples/adr-domain-model.md` — example domain ADR
- `references/examples/adr-schema.md` — example data architecture ADR
