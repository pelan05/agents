# Portable AI Skills for Software Development

A collection of **agent-agnostic prompts/skills** for AI-assisted software development. These work with any AI assistant (Claude, GPT, Gemini, Copilot, etc.) and any project—no specific toolkit required.

## Quick Start

1. Copy the skill file you need into your AI conversation
2. Replace `[PROJECT_ROOT]` with your actual project path
3. Replace `[DOCS_FOLDER]` with where you keep specs (e.g., `docs/`, `specs/`, `requirements/`)
4. Provide your input after the `## User Input` section

## Available Skills

| Skill | Purpose | Use When |
|-------|---------|----------|
| [specify.md](specify.md) | Create feature specifications | Starting a new feature |
| [plan.md](plan.md) | Generate implementation plans | After spec is ready |
| [tasks.md](tasks.md) | Break plans into executable tasks | After plan is ready |
| [implement.md](implement.md) | Execute tasks systematically | Ready to code |
| [clarify.md](clarify.md) | Reduce spec ambiguity | Spec needs refinement |
| [analyze.md](analyze.md) | Cross-check consistency | Before implementation |
| [checklist.md](checklist.md) | Generate quality checklists | QA/review gates |
| [constitution.md](constitution.md) | Define project principles | Project setup |

## Workflow

```
┌─────────────┐    ┌──────────┐    ┌─────────┐    ┌────────────┐
│   specify   │───▶│   plan   │───▶│  tasks  │───▶│ implement  │
└─────────────┘    └──────────┘    └─────────┘    └────────────┘
       │                │               │
       ▼                ▼               ▼
   ┌────────┐      ┌─────────┐    ┌──────────┐
   │ clarify│      │checklist│    │  analyze │
   └────────┘      └─────────┘    └──────────┘
```

## Customization

### Project Structure Variables

Replace these placeholders in each skill:

| Placeholder | Example | Description |
|-------------|---------|-------------|
| `[PROJECT_ROOT]` | `/home/user/myapp` | Absolute path to project |
| `[DOCS_FOLDER]` | `docs/features` | Where specs/plans live |
| `[PRINCIPLES_FILE]` | `docs/constitution.md` | Project principles (optional) |

### Minimal Setup

For a new project, create this structure:

```
your-project/
├── docs/
│   ├── constitution.md    # Project principles (optional)
│   └── features/
│       └── [feature-name]/
│           ├── spec.md
│           ├── plan.md
│           └── tasks.md
└── src/
```

## Usage Examples

### Example 1: Start a New Feature

```
# Paste specify.md content, then:

## User Input

Add user authentication with OAuth2 support
```

### Example 2: Plan an Existing Spec

```
# Paste plan.md content, then:

## User Input

Tech stack: Python/FastAPI, PostgreSQL, Redis for sessions
```

### Example 3: Generate Tasks

```
# Paste tasks.md content, then:

## User Input

Focus on MVP - just basic login/logout first
```

## Adapting to Your Workflow

These skills assume a **specification-first** approach:

1. **Specs** describe *what* (requirements, user stories)
2. **Plans** describe *how* (architecture, tech choices)
3. **Tasks** describe *steps* (ordered, executable work)

You can adapt the folder structure and file naming to match your existing workflow. The core prompts work regardless of where files live.

## License

MIT - Use freely in any project.
