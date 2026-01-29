# Skill: Generate Quality Checklist

**Purpose**: Create domain-specific quality checklists that validate requirements completeness, clarity, and consistency—NOT implementation testing.

**When to use**: Before implementation, during review gates, for QA validation.

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

Specify: checklist domain (UX, API, security, performance, etc.), focus areas, depth level.

---

## Critical Concept: Unit Tests for Requirements

**Checklists are UNIT TESTS FOR REQUIREMENTS WRITING** — they validate the quality of requirements, NOT whether implementation works.

### ❌ WRONG (Testing Implementation)
- "Verify the button clicks correctly"
- "Test error handling works"
- "Confirm the API returns 200"

### ✅ CORRECT (Testing Requirements Quality)
- "Are visual hierarchy requirements defined with measurable criteria?"
- "Is 'prominent display' quantified with specific sizing/positioning?"
- "Are error handling requirements specified for all failure scenarios?"

---

## Execution Instructions

### 1. Clarify Intent

If user input is ambiguous, ask up to 3 questions:

**Question Types**:
- **Scope refinement**: "Include integration touchpoints or local module only?"
- **Risk prioritization**: "Which risk areas need mandatory gating checks?"
- **Depth calibration**: "Lightweight pre-commit list or formal release gate?"
- **Audience framing**: "For author self-check or peer review?"

**Defaults if no answer**:
- Depth: Standard
- Audience: Reviewer (PR review)
- Focus: Top 2 relevance clusters from spec

### 2. Load Feature Context

Read from `[FEATURE_FOLDER]`:
- `spec.md` — Requirements and scope
- `plan.md` — Technical details (if exists)
- `tasks.md` — Implementation tasks (if exists)

### 3. Generate Checklist

Create `[FEATURE_FOLDER]/checklists/[domain].md`:

```markdown
# [Domain] Requirements Quality Checklist

**Feature**: [name]
**Purpose**: Validate [domain] requirements completeness and quality
**Created**: [date]
**Audience**: [author/reviewer/QA]

## Requirement Completeness

- [ ] CHK001 Are all [domain] requirements documented? [Completeness]
- [ ] CHK002 Are [specific requirement type] defined for all [scenarios]? [Completeness, Gap]

## Requirement Clarity

- [ ] CHK003 Is '[vague term]' quantified with specific criteria? [Clarity, Spec §X.Y]
- [ ] CHK004 Are [measurable aspects] explicitly defined? [Clarity]

## Requirement Consistency

- [ ] CHK005 Do [requirements A] align with [requirements B]? [Consistency]
- [ ] CHK006 Are [components] consistently specified across all [contexts]? [Consistency]

## Acceptance Criteria Quality

- [ ] CHK007 Can [requirement] be objectively measured? [Measurability, Spec §X.Y]
- [ ] CHK008 Are success criteria testable without implementation details? [Acceptance]

## Scenario Coverage

- [ ] CHK009 Are [primary flow] requirements complete? [Coverage]
- [ ] CHK010 Are [alternate flow] requirements defined? [Coverage, Gap]
- [ ] CHK011 Are [error/exception flow] requirements specified? [Coverage]

## Edge Case Coverage

- [ ] CHK012 Is behavior defined for [boundary condition]? [Edge Case]
- [ ] CHK013 Are [failure scenario] requirements documented? [Edge Case, Gap]

## Non-Functional Requirements

- [ ] CHK014 Are [performance/security/accessibility] requirements specified? [NFR]
- [ ] CHK015 Are [NFR type] targets measurable? [NFR, Measurability]

## Dependencies & Assumptions

- [ ] CHK016 Are external dependencies documented? [Dependency]
- [ ] CHK017 Are assumptions validated and recorded? [Assumption]

## Ambiguities & Conflicts

- [ ] CHK018 Is the term '[ambiguous term]' clearly defined? [Ambiguity, Spec §X.Y]
- [ ] CHK019 Do [section A] and [section B] have conflicting requirements? [Conflict]

---

## Notes

[Any additional context or explanations]
```

### 4. Checklist Item Rules

**Required Pattern**:
```
- [ ] CHK### [Question about requirement quality] [Quality Dimension, Reference]
```

**Quality Dimensions**:
- `[Completeness]` — Is the requirement present?
- `[Clarity]` — Is it unambiguous and specific?
- `[Consistency]` — Does it align with other requirements?
- `[Measurability]` — Can it be objectively verified?
- `[Coverage]` — Are all scenarios addressed?
- `[Edge Case]` — Are boundary conditions defined?

**References**:
- `[Spec §X.Y]` — Existing requirement section
- `[Gap]` — Missing requirement
- `[Ambiguity]` — Unclear requirement
- `[Conflict]` — Contradicting requirements
- `[Assumption]` — Unstated assumption

### 5. Prohibited Patterns

**NEVER use these (they test implementation, not requirements)**:
- ❌ "Verify", "Test", "Confirm", "Check" + behavior
- ❌ "Displays correctly", "works properly"
- ❌ "Click", "navigate", "render", "load"
- ❌ Implementation details (frameworks, APIs)

**ALWAYS use these patterns**:
- ✅ "Are [requirements] defined/specified/documented for [scenario]?"
- ✅ "Is [vague term] quantified/clarified with specific criteria?"
- ✅ "Are requirements consistent between [A] and [B]?"
- ✅ "Can [requirement] be objectively measured?"
- ✅ "Does the spec define [missing aspect]?"

---

## Domain-Specific Examples

### UX Checklist (`ux.md`)
- "Are visual hierarchy requirements defined with measurable criteria? [Clarity]"
- "Is the number and positioning of UI elements explicitly specified? [Completeness]"
- "Are interaction state requirements (hover, focus, active) consistently defined? [Consistency]"
- "Are accessibility requirements specified for all interactive elements? [Coverage, Gap]"

### API Checklist (`api.md`)
- "Are error response formats specified for all failure scenarios? [Completeness]"
- "Are rate limiting requirements quantified with specific thresholds? [Clarity]"
- "Are authentication requirements consistent across all endpoints? [Consistency]"
- "Is versioning strategy documented in requirements? [Gap]"

### Security Checklist (`security.md`)
- "Are authentication requirements specified for all protected resources? [Coverage]"
- "Are data protection requirements defined for sensitive information? [Completeness]"
- "Is the threat model documented and requirements aligned to it? [Traceability]"

### Performance Checklist (`performance.md`)
- "Are performance requirements quantified with specific metrics? [Clarity]"
- "Are performance targets defined for all critical user journeys? [Coverage]"
- "Can performance requirements be objectively measured? [Measurability]"

---

## Output

Report:
1. Path to created checklist file
2. Item count by quality dimension
3. Focus areas covered
4. Reminder: Each run creates a new file (allows multiple checklists)
