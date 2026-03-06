# Writing tech specs

> **This is a process document.** Follow these steps in order.
> Refer to the planning skill's SKILL.md for shared concepts
> (prerequisites, checkpoints, wiki management).

This stage guides the creation of detailed technical specifications that translate product requirements into implementation plans.

## Output

Creates a `## Tech spec` section within the feature artifact with these subsections:

1. Introduction and overview
2. System design and architecture
3. Detailed design
4. Security, privacy, and compliance
5. Observability
6. Testing plan
7. Alternatives considered
8. Risks

## Prerequisite checklist

Before starting, verify these exist. Follow the planning skill's prerequisite checking pattern for how to handle gaps.

- [ ] Backend API style ADR (REST, GraphQL, gRPC, etc.) in `.eng-docs/adrs/`?
- [ ] Data storage approach ADR in `.eng-docs/adrs/`?
- [ ] Authentication/authorization pattern ADR in `.eng-docs/adrs/`?
- [ ] Frontend state management approach ADR in `.eng-docs/adrs/`?
- [ ] Domain entities defined in `.eng-docs/wiki/domain-model.md`?
- [ ] Relationships and business rules documented?
- [ ] Database schemas for relevant entities in `.eng-docs/wiki/database-schema.md`?
- [ ] API endpoints for relevant services in `.eng-docs/wiki/api-contracts.md`?
- [ ] Dependent features exist in `.eng-docs/specs/`?

**For CRITICAL gaps** (no API style, no domain model, no database): STOP. Do not offer to "document assumptions and proceed." These decisions must be made first.

## Process

### 1. Introduction and overview

- **Prerequisites and assumptions** — list ADRs this feature depends on, assumptions about APIs/models/schemas, dependent features
- **Goals and objectives** — specific, measurable technical goals (e.g., "API responds in under 250ms")
- **Non-goals** — what's explicitly out of scope
- **Glossary** — define acronyms and domain-specific terms

**CHECKPOINT**: Get human approval before proceeding

### 2. System design and architecture

- **High-level architecture** — Mermaid diagram showing how feature fits in existing system. Include services, databases, clients. Brief explanation of key interactions.
- **Component breakdown** — describe each new or modified component
- **Sequence diagrams** — create Mermaid sequenceDiagram for primary user story showing step-by-step data flow. Create additional diagrams for other important/complex flows.

**CHECKPOINT**: Get human approval before proceeding

### 3. Detailed design

- **Data model and schema** — complete schema for new/modified tables. Include table names, columns, types, constraints, relationships. Provide SQL DDL or equivalent. Document migration strategy, data backfill requirements, index creation approach.
- **API contracts** — OpenAPI-like specification for all endpoints. Include HTTP method, path, description, request/response schemas. Specify validation and all possible error responses (4xx, 5xx).
- **Key algorithms or business logic** — detail complex logic with pseudo-code or numbered steps

After defining schemas and API endpoints, update the corresponding wiki documents.

**CHECKPOINT**: Get human approval before proceeding

### 4. Security, privacy, and compliance

- **Authentication and authorization** — access control approach, required roles/permissions per endpoint
- **Data privacy** — identify PII/sensitive data, describe storage/transmission/protection, note compliance requirements (GDPR, HIPAA, etc.)
- **Input validation** — backend validation is mandatory, not optional. Frontend validation is UX, not security. Prevent XSS, SQL injection, etc.

**CHECKPOINT**: Get human approval before proceeding

### 5. Observability

- **Logging** — key events, log levels, message formats
- **Metrics** — what to track (latency, errors, usage)
- **Alerting** — conditions that trigger engineering alerts

### 6. Testing plan

- **Unit tests** — scope for each module/component
- **Integration tests** — key service/database/API interactions
- **E2E tests** — critical user flows for automation

### 7. Alternatives considered

- Describe at least one alternative approach
- Explain pros/cons
- Provide clear rationale for chosen solution

### 8. Risks

- Identify technical risks with mitigation plans
- Resolve open questions before finalizing — work with the human to answer them before proceeding to implementation

**CHECKPOINT**: Get human approval on complete tech spec

## Key guidelines

- You generate the entire tech spec (70-90% effort). Human reviews for accuracy and completeness.
- Examine codebase first to understand existing patterns
- Extend existing code rather than rebuilding
- Simplest solution first — avoid over-engineering
- Only document API changes if actually modifying endpoints
- Only include data model if schema is changing
- **Validation requirements**: all user input endpoints must specify 4xx error responses. Backend validation is mandatory. Never trust client-side validation.

For templates and examples, see:
- `references/examples/tech-spec.md` — complete tech spec example
- `references/templates/api-contract.yaml` — OpenAPI template for API endpoints
