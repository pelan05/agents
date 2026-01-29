# Skill: Create Project Constitution

**Purpose**: Establish or update the foundational principles that govern all development decisions in a project.

**When to use**: Project setup, architectural decisions, team alignment, governance changes.

---

## Configuration

```yaml
project_root: "[PROJECT_ROOT]"        # e.g., /home/user/myapp
principles_file: "[PRINCIPLES_FILE]"  # e.g., docs/constitution.md
```

---

## User Input

```text
$ARGUMENTS
```

Provide: project name, core principles, constraints, or updates to existing constitution.

---

## What is a Project Constitution?

A constitution is the **supreme law** of your project—non-negotiable principles that guide all technical and process decisions. It:

- Defines what the project values most
- Establishes constraints all code must follow
- Provides decision-making framework for ambiguous situations
- Supersedes all other documentation when conflicts arise

---

## Execution Instructions

### 1. Determine Mode

- **Creating new**: No constitution exists
- **Updating existing**: Constitution exists, making amendments

### 2. Collect Principle Information

For each principle, gather:
- **Name**: Short, memorable identifier
- **Description**: What it means in practice
- **Rationale**: Why this matters
- **Examples**: Concrete applications

### 3. Create/Update Constitution

Create or update `[PRINCIPLES_FILE]`:

```markdown
# [PROJECT_NAME] Constitution

**Version**: [X.Y.Z]
**Ratified**: [original date]
**Last Amended**: [amendment date]

---

## Preamble

[Brief statement of project purpose and why these principles matter]

---

## Core Principles

### I. [Principle Name]

**Statement**: [One-sentence principle]

**Rationale**: [Why this matters]

**In Practice**:
- [Specific rule or behavior]
- [Another specific rule]
- [Exception handling if any]

**Examples**:
- ✅ DO: [Good example]
- ❌ DON'T: [Anti-pattern]

---

### II. [Principle Name]

[Same structure]

---

### III. [Principle Name]

[Same structure]

---

## [Optional Sections]

### Technical Constraints

| Constraint | Requirement | Rationale |
|------------|-------------|-----------|
| [Area] | [Requirement] | [Why] |

### Quality Gates

All changes must pass:
- [ ] [Gate 1]
- [ ] [Gate 2]

### Compliance Requirements

[If applicable: regulatory, security, or legal requirements]

---

## Governance

### Amendment Process

1. Propose change with rationale
2. Document impact on existing code/specs
3. Obtain approval from [stakeholders]
4. Update constitution with new version
5. Propagate changes to affected documents

### Version Numbering

- **MAJOR**: Backward-incompatible changes (principle removal/redefinition)
- **MINOR**: New principles or significant expansions
- **PATCH**: Clarifications, typo fixes, non-semantic changes

### Compliance Verification

- All PRs/code reviews must verify constitution compliance
- Violations require justification or code change
- Constitution conflicts are CRITICAL severity

---

## Changelog

### [Version] - [Date]
- [Change description]

### [Previous Version] - [Date]
- [Change description]
```

### 4. Example Principles

#### Library-First
> Every feature starts as a standalone library. Libraries must be self-contained, independently testable, and documented with clear purpose.

#### Test-First (Non-Negotiable)
> TDD mandatory: Tests written → User approved → Tests fail → Then implement. Red-Green-Refactor cycle strictly enforced.

#### Observability by Default
> All services must emit structured logs, metrics, and traces. No deployment without observability.

#### Explicit over Implicit
> Configuration, dependencies, and side effects must be explicit. No magic, no hidden behavior.

#### Fail Fast, Recover Gracefully
> Detect errors early, surface them clearly. Design for graceful degradation under failure.

#### Security as Requirement
> Security is a functional requirement, not an afterthought. Threat modeling before implementation.

### 5. Propagation Checklist

After constitution changes, verify alignment in:
- [ ] Spec templates (requirements sections)
- [ ] Plan templates (architecture constraints)
- [ ] Task templates (quality gates)
- [ ] README and onboarding docs
- [ ] CI/CD pipeline checks

---

## Output

### Creation Report

```markdown
## Constitution Created

**File**: [path]
**Version**: 1.0.0
**Principles**: [count]

### Principles Established

1. **[Principle 1]**: [summary]
2. **[Principle 2]**: [summary]
...

### Next Steps

1. Review constitution with team
2. Ratify and set version 1.0.0
3. Update spec/plan templates to reference principles
4. Add constitution check to review process
```

### Amendment Report

```markdown
## Constitution Amended

**File**: [path]
**Previous Version**: [X.Y.Z]
**New Version**: [X.Y.Z]

### Changes Made

- [Change 1]
- [Change 2]

### Impact Analysis

| Document | Impact | Action Needed |
|----------|--------|---------------|
| spec-template.md | Medium | Update §Requirements |
| plan-template.md | Low | No change |

### Propagation Required

- [ ] [Document 1]
- [ ] [Document 2]
```
