# Skill: Create Implementation Plan

**Purpose**: Transform a feature specification into a detailed technical implementation plan with architecture decisions, data models, and API contracts.

**When to use**: After specification is complete, before task breakdown.

---

## Configuration

```yaml
project_root: "[PROJECT_ROOT]"        # e.g., /home/user/myapp
docs_folder: "[DOCS_FOLDER]"          # e.g., docs/features
principles_file: "[PRINCIPLES_FILE]"  # e.g., docs/constitution.md (optional)
feature_folder: "[FEATURE_FOLDER]"    # e.g., docs/features/user-auth
```

---

## User Input

```text
$ARGUMENTS
```

Provide: tech stack preferences, constraints, architectural context.

---

## Execution Instructions

### 1. Load Context

Read these files (if they exist):
- `[FEATURE_FOLDER]/spec.md` — Feature requirements
- `[PRINCIPLES_FILE]` — Project principles/constraints (optional)

### 2. Create Plan Structure

Create `[FEATURE_FOLDER]/plan.md`:

```markdown
# Implementation Plan: [Feature Name]

**Spec**: [link to spec.md]
**Created**: [DATE]
**Tech Stack**: [from user input]

## Technical Context

### Stack Selection
| Component | Technology | Rationale |
|-----------|------------|-----------|
| Language | [e.g., Python 3.11] | [why] |
| Framework | [e.g., FastAPI] | [why] |
| Database | [e.g., PostgreSQL 15] | [why] |
| Cache | [e.g., Redis] | [why] |

### Architecture Pattern
[e.g., Layered architecture with Controllers → Services → Repositories]

### Project Structure
```text
src/
├── models/          # Data models
├── services/        # Business logic
├── api/             # API endpoints
├── repositories/    # Data access
└── utils/           # Shared utilities
```

## Principles Check

[If principles_file exists, verify alignment]

| Principle | Status | Notes |
|-----------|--------|-------|
| [Principle 1] | ✓ Compliant | [how] |
| [Principle 2] | ⚠ Partial | [gap] |

## Data Model

### Entities

#### [Entity1]
```
[Entity1]
├── id: UUID (PK)
├── name: String (required, max 255)
├── status: Enum [active, inactive]
├── created_at: DateTime
└── relationships
    └── belongs_to: [Entity2]
```

#### [Entity2]
...

### Database Schema

```sql
CREATE TABLE [entity1] (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW()
);
```

## API Contracts

### Endpoints Overview

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | /api/v1/[resource] | Create | Required |
| GET | /api/v1/[resource]/{id} | Get by ID | Required |
| PUT | /api/v1/[resource]/{id} | Update | Required |
| DELETE | /api/v1/[resource]/{id} | Delete | Required |

### Contract Details

#### POST /api/v1/[resource]

**Request**:
```json
{
  "name": "string",
  "description": "string (optional)"
}
```

**Response** (201):
```json
{
  "id": "uuid",
  "name": "string",
  "created_at": "datetime"
}
```

**Errors**:
- 400: Validation failed
- 401: Unauthorized
- 409: Conflict (duplicate)

## Implementation Phases

### Phase 1: Foundation
- [ ] Project setup and dependencies
- [ ] Database schema and migrations
- [ ] Base models and repositories

### Phase 2: Core Logic
- [ ] Service layer implementation
- [ ] Business rule validation
- [ ] Error handling

### Phase 3: API Layer
- [ ] Endpoint implementation
- [ ] Request/response validation
- [ ] Authentication integration

### Phase 4: Integration
- [ ] External service connections
- [ ] Event handling (if applicable)
- [ ] Caching layer

### Phase 5: Polish
- [ ] Logging and monitoring
- [ ] Documentation
- [ ] Performance optimization

## Technical Decisions

### Decision 1: [Topic]
- **Context**: [situation requiring decision]
- **Decision**: [what was chosen]
- **Rationale**: [why this choice]
- **Alternatives Considered**: [what else was evaluated]

## Dependencies

### External Services
- [Service 1]: [purpose, failure handling]

### Libraries
- [Library 1]: [version, purpose]

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk 1] | High | [mitigation strategy] |

## Open Questions

- [ ] [Technical question needing resolution]
```

### 3. Generate Supporting Documents

If complexity warrants, create:

**`[FEATURE_FOLDER]/data-model.md`** — Detailed entity definitions
**`[FEATURE_FOLDER]/contracts/`** — OpenAPI/GraphQL schemas
**`[FEATURE_FOLDER]/research.md`** — Technology evaluations

### 4. Research Phase

For each "NEEDS CLARIFICATION" or technical unknown:
1. Research options
2. Document decision with rationale
3. List alternatives considered

### 5. Validation

Verify:
- [ ] All spec requirements have technical solutions
- [ ] Architecture supports non-functional requirements
- [ ] No spec requirements were dropped
- [ ] Principles compliance checked (if applicable)

---

## Output

Report:
1. Path to created plan.md
2. List of generated artifacts (data-model, contracts, etc.)
3. Any unresolved technical questions
4. Suggested next step: "Run the **tasks** skill to create executable task list"
