# Skill: Generate Task List

**Purpose**: Break down an implementation plan into ordered, executable tasks with dependencies and parallelization opportunities.

**When to use**: After plan is complete, before implementation.

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

Optional context: MVP scope, priority focus, test requirements.

---

## Execution Instructions

### 1. Load Design Documents

Read from `[FEATURE_FOLDER]`:
- **Required**: `plan.md` (tech stack, architecture, phases)
- **Required**: `spec.md` (user stories with priorities)
- **Optional**: `data-model.md` (entities)
- **Optional**: `contracts/` (API endpoints)
- **Optional**: `research.md` (technical decisions)

### 2. Create Task File

Create `[FEATURE_FOLDER]/tasks.md`:

```markdown
# Tasks: [Feature Name]

**Plan**: [link to plan.md]
**Generated**: [DATE]
**Total Tasks**: [count]

## Task Format

```
- [ ] T### [P] [US#] Description with file path
```

- `T###`: Sequential task ID (T001, T002...)
- `[P]`: Parallelizable (different files, no dependencies)
- `[US#]`: User story reference (US1, US2... from spec)

---

## Phase 1: Setup

Project initialization and configuration.

- [ ] T001 Initialize project structure per plan.md
- [ ] T002 Configure dependencies in [package file]
- [ ] T003 [P] Create configuration files
- [ ] T004 [P] Set up development environment

---

## Phase 2: Foundation

Blocking prerequisites for all user stories.

- [ ] T005 Create database migrations in [path]
- [ ] T006 Implement base model classes in [path]
- [ ] T007 [P] Create shared utilities in [path]
- [ ] T008 [P] Set up logging configuration in [path]

---

## Phase 3: User Story 1 - [Story Title]

**Goal**: [User story goal from spec]
**Acceptance**: [Key acceptance criteria]

### Models & Data
- [ ] T009 [US1] Create [Model] in src/models/[file].py
- [ ] T010 [P] [US1] Create [Model] repository in src/repositories/[file].py

### Business Logic
- [ ] T011 [US1] Implement [Service] in src/services/[file].py
- [ ] T012 [US1] Add validation rules for [Model]

### API/Interface
- [ ] T013 [US1] Create [endpoint] in src/api/[file].py
- [ ] T014 [P] [US1] Add request/response schemas

### Tests (if requested)
- [ ] T015 [P] [US1] Write unit tests for [Service]
- [ ] T016 [US1] Write integration tests for [endpoint]

---

## Phase 4: User Story 2 - [Story Title]

[Same structure as Phase 3]

---

## Phase N: Polish & Cross-Cutting

- [ ] T0XX Add comprehensive error handling
- [ ] T0XX [P] Add API documentation
- [ ] T0XX [P] Performance optimization
- [ ] T0XX Final integration testing

---

## Dependencies

```
T001 ─┬─► T005 ─► T009 ─► T011 ─► T013
      │
      └─► T002 ─► T006 ─► T010 (parallel with T009)
```

## Parallel Execution Groups

**Group A** (can run simultaneously):
- T003, T004, T007, T008

**Group B** (after Phase 2):
- T009, T010 (different files, no dependencies)

## Implementation Strategy

1. **MVP First**: Complete Phase 1-3 (User Story 1) for working vertical slice
2. **Incremental**: Each user story phase is independently deployable
3. **Test Coverage**: [If TDD requested, tests before implementation]

## Estimated Effort

| Phase | Tasks | Complexity | Est. Time |
|-------|-------|------------|-----------|
| Setup | 4 | Low | 1-2 hours |
| Foundation | 4 | Medium | 2-4 hours |
| US1 | 8 | Medium | 4-8 hours |
| ... | ... | ... | ... |
```

### 3. Task Generation Rules

**Task Organization by User Story**:
- Each user story from spec.md gets its own phase
- Map components (models, services, endpoints) to their story
- Mark inter-story dependencies

**Task Format Requirements**:
- ✅ `- [ ] T001 Create project structure per plan.md`
- ✅ `- [ ] T005 [P] Implement auth middleware in src/middleware/auth.py`
- ✅ `- [ ] T012 [P] [US1] Create User model in src/models/user.py`
- ❌ `Create User model` (missing checkbox, ID)
- ❌ `T001 Create model` (missing checkbox)
- ❌ `- [ ] T001 [US1] Create model` (missing file path)

**Parallelization Rules**:
- Mark `[P]` only if: different files AND no dependencies on incomplete tasks
- Tasks on same file = sequential
- Tasks with data dependencies = sequential

**Tests**:
- Only include test tasks if explicitly requested
- If TDD: test tasks come before implementation tasks

### 4. Validation

Verify:
- [ ] Every user story has complete task coverage
- [ ] All plan phases are represented
- [ ] Dependencies are explicit
- [ ] File paths are specific
- [ ] Each task is independently executable by an AI

---

## Output

Report:
1. Path to created tasks.md
2. Summary:
   - Total task count
   - Tasks per user story
   - Parallel opportunities identified
3. MVP scope suggestion (typically User Story 1)
4. Suggested next step: "Run the **implement** skill to execute tasks"
