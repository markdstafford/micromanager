---
name: writing-guidelines
description: >
  Use when drafting planning content, reviewing written artifacts
  for clarity, or uncertain about language, style, or tone in
  product requirements, technical designs, or other semi-technical
  documentation.
---

# Writing guidelines

Style guidance for semi-technical writing that is simple, straightforward, and effective for both human review and LLM consumption.

## When to use

- Drafting any planning content (requirements, specs, narratives, task descriptions)
- Reviewing written artifacts for clarity and tone
- Uncertain about appropriate language or style
- Content feels too complex or jargon-heavy

## Style principles

### Language and clarity

- Use simple, common words over fancy alternatives
- Avoid business jargon and buzzwords ("use" not "leverage")
- Be specific and concrete with numbers, examples, and precise terms
- One idea per sentence when possible
- Paragraphs should be 3-5 sentences maximum
- Define technical terms on first use or link to glossary

### Voice and structure

- Use active voice ("system processes requests" not "requests are processed")
- Write in present tense for current documentation
- Start with action verbs in task descriptions and instructions
- Use second person for instructions ("you configure" not "the user configures")
- Passive voice is acceptable when actor is unknown ("database is backed up daily")

### Technical content

- Use technical terms when they add precision and clarity
- Match technical depth to audience and document type
- Provide clear descriptions over vague language such as "robust"
- Show concrete examples: code snippets, API samples, specific scenarios
- Product requirements focus on user perspective, tech specs contain implementation details
- Technical terms and acronyms like "CRDT" and "WebSocket" are fine when precise and necessary

### Organization and formatting

- Use headings and lists to break up text for scannability
- One topic per section — don't mix unrelated concepts
- Use parallel structure in lists (all items follow same grammatical pattern)
- Sentence case for headings ("Getting started" not "Getting Started")
- Backticks for inline code: `filename.js`, `/api/endpoint`
- Fenced code blocks for multi-line code, schemas, API examples

### Tone and consistency

- Write for your audience's expertise level
- Be direct and honest — avoid marketing language in technical docs
- Be consistent with terminology throughout (pick "user" or "customer", not both)
- Omit needless words ("due to the fact that" → "because")

## Document-specific guidance

**Product requirements (What/Why):**
- User-focused language, minimize implementation details
- Concrete outcomes and behaviors
- Avoid vague benefits like "better experience"

**Narratives:**
- Natural, conversational storytelling with persona names
- Specific actions and observations
- Short paragraphs showing features through use

**Design and tech specs:**
- Technical precision is important
- Architecture, APIs, data models, algorithms
- Technical terms are expected and appropriate

**Task descriptions:**
- Start with action verb
- Clear acceptance criteria
- Specific and unambiguous

## Review checklist

- [ ] No unnecessary jargon (or defined if necessary)
- [ ] Active voice where appropriate
- [ ] Specific rather than abstract
- [ ] Appropriate technical depth for document type
- [ ] Short paragraphs (3-5 sentences)
- [ ] Sentence case headings
- [ ] Strong, clear verbs
- [ ] Parallel structure in lists
- [ ] Consistent terminology

## When to break the rules

These are guidelines, not absolute rules. Break them when:
- Technical precision requires specific terminology
- Domain conventions make certain terms unavoidable
- Passive voice improves clarity
- Human explicitly prefers different style

Always prioritize clarity and communication effectiveness.
