# Skill: Execute Implementation

**Purpose**: Systematically execute tasks from the task list, creating files and code according to the implementation plan.

**When to use**: After tasks are defined, ready to write code.

---

## Configuration

```yaml
project_root: "[PROJECT_ROOT]"        # e.g., /home/user/myapp
docs_folder: "[DOCS_FOLDER]"          # e.g., docs/features
feature_folder: "[FEATURE_FOLDER]"    # e.g., docs/features/user-auth
```

---

## User Input

```text
$ARGUMENTS
```

Optional: specific phase to execute, task range, or focus area.

---

## Execution Instructions

### 1. Load Implementation Context

Read from `[FEATURE_FOLDER]`:
- **Required**: `tasks.md` — Task list and execution plan
- **Required**: `plan.md` — Tech stack, architecture, file structure
- **Optional**: `data-model.md` — Entity definitions
- **Optional**: `contracts/` — API specifications
- **Optional**: `spec.md` — Original requirements for validation

### 2. Pre-Implementation Checks

#### Checklist Validation (if checklists exist)

If `[FEATURE_FOLDER]/checklists/` exists:

```
| Checklist | Total | Complete | Incomplete | Status |
|-----------|-------|----------|------------|--------|
| ux.md     | 12    | 12       | 0          | ✓ PASS |
| api.md    | 8     | 5        | 3          | ✗ FAIL |
```

- **If any incomplete**: Ask user to confirm proceeding
- **If all complete**: Continue automatically

#### Project Setup Verification

Create/verify ignore files based on detected tech stack:

**Common patterns by technology**:

| Tech | Ignore Patterns |
|------|-----------------|
| **Node.js** | `node_modules/`, `dist/`, `build/`, `*.log`, `.env*` |
| **Python** | `__pycache__/`, `*.pyc`, `.venv/`, `venv/`, `dist/` |
| **Java** | `target/`, `*.class`, `*.jar`, `.gradle/`, `build/` |
| **Go** | `*.exe`, `*.test`, `vendor/`, `*.out` |
| **Rust** | `target/`, `debug/`, `release/`, `Cargo.lock` |
| **Universal** | `.DS_Store`, `Thumbs.db`, `*.tmp`, `.idea/`, `.vscode/` |

### 3. Parse Task Structure

Extract from `tasks.md`:
- **Phases**: Setup → Foundation → User Stories → Polish
- **Dependencies**: Sequential vs parallel execution
- **Task details**: ID, description, file paths, `[P]` markers

### 4. Execute Tasks

#### Execution Rules

1. **Phase-by-phase**: Complete each phase before moving to next
2. **Respect dependencies**: Sequential tasks in order, `[P]` tasks can run together
3. **File-based coordination**: Tasks affecting same file = sequential
4. **Validation checkpoints**: Verify phase completion before proceeding

#### Execution Order

```
Phase 1: Setup
├── T001 (sequential)
├── T002 (sequential)
└── T003, T004 [P] (parallel)

Phase 2: Foundation
├── T005 (sequential - blocking)
└── T006, T007, T008 [P] (parallel after T005)

Phase 3+: User Stories
├── Models (sequential within story)
├── Services (after models)
├── API (after services)
└── Tests (if requested, after implementation)
```

#### Per-Task Execution

For each task:

1. **Read task description** — Understand what to create
2. **Load relevant context** — Data models, contracts, existing code
3. **Create/modify file** — Follow plan.md architecture
4. **Validate** — Syntax check, imports resolve
5. **Mark complete** — Update tasks.md: `- [ ]` → `- [x]`

### 5. Progress Tracking

After each task:
```markdown
✓ T001 - Initialize project structure
✓ T002 - Configure dependencies  
→ T003 - [IN PROGRESS] Create configuration files
○ T004 - Set up development environment
```

#### Error Handling

- **Non-parallel task fails**: Halt and report
- **Parallel task fails**: Continue others, report failed
- **Blocking dependency fails**: Cannot proceed, suggest fixes

### 6. Implementation Standards

#### Code Quality

- Follow language idioms and conventions
- Include docstrings/comments for public APIs
- Handle errors explicitly
- Use type hints where applicable

#### File Creation Pattern

```python
# Example: Creating a service file

# 1. Read data model for entity structure
# 2. Read contracts for API requirements
# 3. Create service with:
#    - Required imports
#    - Class/function definitions
#    - Business logic from plan
#    - Error handling
#    - Type hints
```

### 7. Completion Validation

After all tasks:

- [ ] All tasks marked complete in tasks.md
- [ ] Implementation matches spec requirements
- [ ] Code follows plan.md architecture
- [ ] No unresolved TODO markers
- [ ] Tests pass (if tests were included)

---

## Output

### Progress Report

```markdown
## Implementation Summary

**Feature**: [name]
**Tasks Completed**: [X/Y]
**Phases Completed**: [list]

### Files Created
- src/models/user.py
- src/services/user_service.py
- src/api/users.py
- tests/test_user_service.py

### Files Modified
- src/config.py (added settings)
- requirements.txt (added dependencies)

### Remaining Work
- [ ] T045 - Performance optimization
- [ ] T046 - Documentation

### Issues Encountered
- [Any blockers or decisions made]

### Next Steps
1. Run tests: `[test command]`
2. Review changes: `git diff`
3. Continue with remaining tasks
```
