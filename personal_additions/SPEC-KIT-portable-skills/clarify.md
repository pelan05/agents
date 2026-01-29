# Skill: Clarify Specification

**Purpose**: Identify underspecified areas in a feature spec by asking targeted clarification questions and encoding answers back into the spec.

**When to use**: After initial spec, before planning, when ambiguities exist.

---

## Configuration

```yaml
project_root: "[PROJECT_ROOT]"        # e.g., /home/user/myapp
feature_folder: "[FEATURE_FOLDER]"    # e.g., docs/features/user-auth
```

---

## User Input

```text
$ARGUMENTS
```

Optional: specific areas to focus clarification on.

---

## Execution Instructions

### 1. Load Current Spec

Read `[FEATURE_FOLDER]/spec.md`

### 2. Ambiguity & Coverage Scan

Analyze the spec using this taxonomy. Mark each area: **Clear** | **Partial** | **Missing**

#### Functional Scope & Behavior
- [ ] Core user goals & success criteria
- [ ] Explicit out-of-scope declarations
- [ ] User roles/personas differentiation

#### Domain & Data Model
- [ ] Entities, attributes, relationships
- [ ] Identity & uniqueness rules
- [ ] Lifecycle/state transitions
- [ ] Data volume/scale assumptions

#### Interaction & UX Flow
- [ ] Critical user journeys/sequences
- [ ] Error/empty/loading states
- [ ] Accessibility or localization notes

#### Non-Functional Quality Attributes
- [ ] Performance (latency, throughput targets)
- [ ] Scalability (limits, growth expectations)
- [ ] Reliability & availability
- [ ] Observability (logging, metrics)
- [ ] Security & privacy
- [ ] Compliance/regulatory constraints

#### Integration & External Dependencies
- [ ] External services/APIs and failure modes
- [ ] Data import/export formats
- [ ] Protocol/versioning assumptions

#### Edge Cases & Failure Handling
- [ ] Negative scenarios
- [ ] Rate limiting/throttling
- [ ] Conflict resolution (concurrent edits)

#### Constraints & Tradeoffs
- [ ] Technical constraints
- [ ] Explicit tradeoffs or rejected alternatives

#### Terminology & Consistency
- [ ] Canonical glossary terms
- [ ] Consistent naming throughout

#### Completion Signals
- [ ] Acceptance criteria testability
- [ ] Measurable definition of done

#### Placeholders & Ambiguities
- [ ] TODO markers/unresolved decisions
- [ ] Vague adjectives ("robust", "intuitive") lacking quantification

### 3. Generate Clarification Questions

**Rules**:
- Maximum **5 questions** per session
- Maximum **10 questions** across all clarification sessions
- Each question must be answerable with:
  - Short multiple-choice (2-5 options), OR
  - One-word/short-phrase answer (≤5 words)

**Prioritize by impact**:
1. Questions affecting architecture/data modeling
2. Questions affecting test design
3. Questions affecting UX behavior
4. Questions affecting operational readiness

**Question Format**:

```markdown
## Clarification Questions

### Q1: [Category] - [Topic]

[Question text]

**Options**:
A) [Option 1] - [implication]
B) [Option 2] - [implication]
C) [Option 3] - [implication]

**Default if not answered**: [reasonable default]
```

**Skip questions if**:
- Already answered elsewhere in spec
- Trivial stylistic preference
- Better deferred to planning phase
- Clarification wouldn't change implementation

### 4. Encode Answers

After receiving answers, update `spec.md`:

1. **Replace** any `[NEEDS CLARIFICATION: ...]` markers with decisions
2. **Add** details to relevant sections
3. **Document** in Assumptions section if answer creates an assumption
4. **Remove** ambiguous adjectives, replace with specific metrics

### 5. Validation

After updates:
- Count remaining `[NEEDS CLARIFICATION]` markers
- If 0: Spec is ready for planning
- If >0: May need another clarification round (ask user)

---

## Question Templates by Category

### Functional Scope
- "Should [feature] include [capability A] or is that out of scope?"
- "When [condition], should the system [behavior A] or [behavior B]?"

### Data Model
- "Is [entity] unique by [field A], [field B], or both?"
- "Can [entity] exist without a [related entity]?"

### Non-Functional
- "What's the acceptable latency for [operation]: <100ms, <500ms, or <2s?"
- "Expected concurrent users: <100, <1000, or <10000?"

### Edge Cases
- "When [error condition], should the system [fail loudly], [fail silently], or [retry]?"
- "If [external service] is unavailable, should we [queue], [reject], or [degrade]?"

### Security
- "Is [data type] considered PII requiring encryption at rest?"
- "Should [operation] require [auth level A] or [auth level B]?"

---

## Output

### Coverage Report

```markdown
## Clarification Summary

**Spec**: [feature-name]/spec.md
**Session**: [date]

### Coverage Status

| Category | Before | After |
|----------|--------|-------|
| Functional Scope | Partial | Clear |
| Data Model | Missing | Partial |
| Non-Functional | Clear | Clear |
| Edge Cases | Missing | Clear |

### Questions Asked
1. Q1: [topic] → Answer: [A/B/C]
2. Q2: [topic] → Answer: [response]
...

### Spec Updates Made
- Added: [section/detail]
- Clarified: [section/detail]
- Resolved: [NEEDS CLARIFICATION marker]

### Remaining Ambiguities
- [If any, list them]

### Next Steps
- [Ready for planning] OR [Another clarification round recommended]
```
