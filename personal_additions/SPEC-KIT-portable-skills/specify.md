# Skill: Create Feature Specification

**Purpose**: Transform a natural language feature description into a structured, implementation-ready specification.

**When to use**: Starting a new feature, documenting requirements, before technical planning.

---

## Configuration

```yaml
project_root: "[PROJECT_ROOT]"        # e.g., /home/user/myapp
docs_folder: "[DOCS_FOLDER]"          # e.g., docs/features
principles_file: "[PRINCIPLES_FILE]"  # e.g., docs/constitution.md (optional)
```

---

## User Input

```text
$ARGUMENTS
```

---

## Execution Instructions

Given the feature description above, execute this workflow:

### 1. Generate Feature Identity

- Create a **short name** (2-4 words) that captures the feature essence
- Use action-noun format: `user-auth`, `payment-processing`, `dashboard-analytics`
- Preserve technical terms: OAuth2, API, JWT, GraphQL

### 2. Create Specification File

Create `[DOCS_FOLDER]/[feature-short-name]/spec.md` with this structure:

```markdown
# Feature: [Feature Name]

**Short Name**: [feature-short-name]
**Created**: [DATE]
**Status**: Draft

## Overview

[2-3 sentence description of what this feature does and why it matters]

## Problem Statement

[What problem does this solve? Who has this problem?]

## User Stories

### US1: [Primary User Story]
**As a** [user type]
**I want to** [action]
**So that** [benefit]

**Acceptance Criteria**:
- [ ] [Criterion 1]
- [ ] [Criterion 2]

### US2: [Secondary User Story]
...

## Functional Requirements

### FR1: [Requirement Name]
[Description of what the system must do]
- Inputs: [what triggers this]
- Outputs: [what it produces]
- Rules: [business logic constraints]

### FR2: ...

## Non-Functional Requirements

### NFR1: Performance
- [Specific, measurable targets: "Page load < 2s on 3G"]

### NFR2: Security
- [Authentication/authorization requirements]

### NFR3: Scalability
- [Load expectations, growth projections]

## Key Entities (Data Model Hints)

| Entity | Key Attributes | Relationships |
|--------|---------------|---------------|
| [Entity1] | id, name, ... | belongs to [Entity2] |

## Edge Cases & Error Handling

- **When** [condition], **then** [expected behavior]
- **When** [error condition], **then** [error handling]

## Out of Scope

- [Explicit exclusions to prevent scope creep]

## Assumptions

- [Things assumed true that affect design decisions]

## Success Criteria

How we know this feature is successful:
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]

## Open Questions

- [ ] [Question needing resolution before implementation]
```

### 3. Content Generation Rules

**DO**:
- Extract actors, actions, data, constraints from the description
- Make informed assumptions for unclear details (document them)
- Create testable, specific requirements
- Use technology-agnostic language in specs

**DON'T**:
- Include implementation details (languages, frameworks, APIs)
- Leave vague adjectives ("fast", "secure", "robust") without metrics
- Assume technical choices before planning phase

### 4. Clarification Handling

For unclear aspects:
- Make reasonable assumptions based on context
- Mark truly ambiguous items with: `[NEEDS CLARIFICATION: specific question]`
- **Limit**: Maximum 3 clarification markers (prioritize by impact)

### 5. Quality Validation

After writing, verify:
- [ ] All user stories have acceptance criteria
- [ ] Functional requirements are testable
- [ ] Non-functional requirements have measurable targets
- [ ] Success criteria are specific and achievable
- [ ] No implementation details leaked into spec

---

## Output

Report:
1. Path to created spec file
2. Summary of user stories identified
3. Any clarification markers that need resolution
4. Suggested next step: "Run the **plan** skill to create implementation plan"
