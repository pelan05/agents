# Skill: Analyze for Consistency

**Purpose**: Perform non-destructive cross-artifact consistency and quality analysis across spec, plan, and tasks before implementation.

**When to use**: After tasks are generated, before implementation, as a quality gate.

---

## Configuration

```yaml
project_root: "[PROJECT_ROOT]"        # e.g., /home/user/myapp
feature_folder: "[FEATURE_FOLDER]"    # e.g., docs/features/user-auth
principles_file: "[PRINCIPLES_FILE]"  # e.g., docs/constitution.md (optional)
```

---

## User Input

```text
$ARGUMENTS
```

Optional: specific areas to focus analysis on.

---

## Operating Constraints

**STRICTLY READ-ONLY**: Do not modify any files. Output a structured analysis report only.

**Principles Authority**: If a principles file exists, it is non-negotiable. Conflicts are automatically CRITICAL severity.

---

## Execution Instructions

### 1. Load Artifacts

Read from `[FEATURE_FOLDER]`:
- `spec.md` — Feature requirements (required)
- `plan.md` — Technical plan (required)  
- `tasks.md` — Task breakdown (required)
- `[PRINCIPLES_FILE]` — Project principles (optional)

### 2. Build Semantic Models

Create internal representations:

**Requirements Inventory**:
- Each functional + non-functional requirement
- Generate stable keys (e.g., "user-can-upload-file")

**User Story Inventory**:
- Discrete user actions
- Acceptance criteria

**Task Coverage Mapping**:
- Map each task to requirements/stories
- Identify orphan tasks (no requirement traced)
- Identify uncovered requirements (no task)

**Principles Rule Set** (if applicable):
- Extract MUST/SHOULD statements
- Map to affected artifacts

### 3. Detection Passes

Limit to **50 findings total**. Prioritize by severity.

#### A. Duplication Detection

- Near-duplicate requirements
- Overlapping tasks
- Redundant acceptance criteria

**Output**:
```markdown
### DUP-001: Duplicate Requirement
- **Location**: spec.md §FR-3, spec.md §FR-7
- **Issue**: Both describe user login flow
- **Recommendation**: Consolidate into single requirement
```

#### B. Ambiguity Detection

- Vague adjectives: "fast", "scalable", "secure", "intuitive", "robust"
- Missing measurable criteria
- Unresolved placeholders: TODO, TKTK, ???, `<placeholder>`

**Output**:
```markdown
### AMB-001: Unmeasurable Requirement
- **Location**: spec.md §NFR-2
- **Issue**: "System should be fast" - no latency target
- **Recommendation**: Define specific target (e.g., "<200ms p95")
```

#### C. Underspecification

- Requirements missing outcomes
- User stories missing acceptance criteria
- Tasks referencing undefined components

**Output**:
```markdown
### UND-001: Missing Acceptance Criteria
- **Location**: spec.md §US-3
- **Issue**: User story has no acceptance criteria
- **Recommendation**: Add testable acceptance criteria
```

#### D. Coverage Gaps

- Requirements not traced to tasks
- Tasks not traced to requirements
- API contracts without implementation tasks

**Output**:
```markdown
### GAP-001: Uncovered Requirement
- **Location**: spec.md §FR-8
- **Issue**: "User can export data" has no implementing task
- **Recommendation**: Add task in tasks.md Phase 4
```

#### E. Consistency Violations

- Plan architecture vs task structure mismatch
- Spec entities vs data model mismatch
- Contract endpoints vs task coverage mismatch

**Output**:
```markdown
### CON-001: Architecture Mismatch
- **Location**: plan.md §Structure vs tasks.md Phase 2
- **Issue**: Plan specifies src/services/ but tasks create src/service/
- **Recommendation**: Align path naming
```

#### F. Principles Alignment (if applicable)

- Violations of MUST statements
- Partial compliance with SHOULD statements

**Output**:
```markdown
### PRI-001: Principle Violation [CRITICAL]
- **Principle**: "All APIs must have contract tests"
- **Location**: tasks.md
- **Issue**: No contract test tasks defined
- **Recommendation**: Add contract test tasks before API implementation
```

### 4. Severity Classification

| Severity | Criteria | Action |
|----------|----------|--------|
| **CRITICAL** | Blocks implementation, principle violation | Must fix before proceeding |
| **HIGH** | Causes rework or bugs | Should fix before implementation |
| **MEDIUM** | Quality concern | Fix during implementation |
| **LOW** | Minor improvement | Optional fix |

---

## Output

### Analysis Report

```markdown
# Consistency Analysis Report

**Feature**: [name]
**Analyzed**: [date]
**Artifacts**: spec.md, plan.md, tasks.md

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 2 |
| HIGH | 5 |
| MEDIUM | 8 |
| LOW | 3 |

**Verdict**: [PASS / PASS WITH WARNINGS / FAIL]

## Critical Issues (Must Fix)

### PRI-001: [Title]
...

### GAP-001: [Title]
...

## High Priority Issues (Should Fix)

### CON-001: [Title]
...

## Medium Priority Issues

[Grouped list]

## Low Priority Issues

[Grouped list]

## Coverage Matrix

| Requirement | Plan Section | Tasks | Status |
|-------------|--------------|-------|--------|
| FR-1 | §Architecture | T009, T010 | ✓ Covered |
| FR-2 | §Data Model | T011 | ✓ Covered |
| FR-3 | - | - | ✗ Uncovered |

## Remediation Plan (Optional)

If user approves, these fixes would be applied:

1. [ ] Add missing task for FR-3
2. [ ] Clarify NFR-2 latency target
3. [ ] Fix path inconsistency in tasks

**Note**: This report is read-only. Run remediation manually or approve for follow-up editing.
```
