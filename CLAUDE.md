# Nilfheim NixOS Configuration - AI Agent Guidelines

This NixOS configuration follows **dendritic principles** for aspect-oriented, modular configuration management. All AI agents must follow the workflow and rules below.

## 🔴 Critical Rules

**These rules override all others and must be followed strictly:**

1. **Use Explore Agent**: For codebase investigation, use `Task` tool with `subagent_type=Explore` (not direct Grep/Glob for open-ended searches)
2. **Use TodoWrite**: Create task list in PLAN phase, update as you work through implementation
3. **Git Add Immediately**: After creating any `.nix` file, run `git add path/to/file.nix` - import-tree only loads git-tracked files
4. **Wait for Approval**: Do not start CODE phase without explicit user approval of plan
5. **All Checks Must Pass**: Do not commit until alejandra, statix, and deadnix all pass

**When stuck:** See [troubleshooting.md](docs/reference/troubleshooting.md) for error recovery.

---

## Mandatory Workflow: Explore → Plan → Code → Commit

Every task MUST follow these four phases with explicit checkpoints. **DO NOT skip phases or checkpoints.**

### Phase 1: EXPLORE (Read-Only)

**Goal:** Understand the codebase and gather context.

**Actions:**
- Use Task tool with `subagent_type=Explore` for codebase investigation
- Read relevant files, documentation, and existing implementations
- Search for similar patterns or related features
- Ask clarifying questions if requirements are unclear

**RULES:**
- ✗ DO NOT write, edit, or create any files
- ✗ DO NOT propose solutions or implementation details
- ✓ DO use Read, Grep, Glob, and Explore agents

**STOP:** After exploration, present findings and ask: "Ready to move to planning phase?"

---

### Phase 2: PLAN (Design-Only)

**Goal:** Design a solution that preserves dendritic architecture.

**Actions:**
- **Use TodoWrite to create implementation task list** (required)
- Propose an implementation approach
- Identify which modules need changes
- Determine if new modules are needed (and where they belong - see Module Placement below)
- Plan testing and verification strategy

**RULES:**
- ✗ DO NOT write, edit, or create any files
- ✓ DO document the plan clearly with TodoWrite
- ✓ DO explain architectural decisions
- ✓ DO identify which files will be created/modified

**STOP:** Present the plan and ask: "Does this plan look good? Should I proceed to implementation?"

**CHECKPOINT:** Wait for explicit user approval before proceeding.

---

### Phase 3: CODE (Implementation)

**Goal:** Implement the planned solution.

**Actions:**
- Follow the approved plan exactly
- Create or modify files as planned
- **IMMEDIATELY `git add` any newly created `.nix` files** (critical - import-tree only loads tracked files)
- Update TodoWrite status (mark in_progress, then completed) as you work
- Test changes incrementally if possible

**RULES:**
- ✓ DO implement only what was approved in the plan
- ✓ DO `git add` new files immediately after creating them
- ✓ DO update todos as you work (one in_progress at a time)
- ✗ DO NOT create git commits yet
- ✗ DO NOT deviate from the approved plan without asking

**CRITICAL:** If you create a new `.nix` file and don't `git add` it, the flake will not see it and evaluation will fail with confusing errors (e.g., "option defined multiple times"). See [troubleshooting.md](docs/reference/troubleshooting.md#import-tree-issues).

**STOP:** After implementation, run quality checks (next section).

---

### Phase 4: COMMIT (Finalize)

**Goal:** Verify quality and create commits.

**REQUIRED CHECKS (All must pass):**

```bash
alejandra --check .    # Format check
statix check .         # Linting
deadnix --fail .       # Dead code detection
nix flake check --impure  # Build verification (if applicable)
```

**Actions:**
1. Run all quality checks above
2. Fix any issues found (see [troubleshooting.md](docs/reference/troubleshooting.md) if needed)
3. Present a summary of all changes made
4. Create git commit only after user confirmation

**RULES:**
- ✗ DO NOT commit until ALL checks pass
- ✗ DO NOT commit until user confirms they're happy with changes
- ✓ DO use Conventional Commits format: `<type>(<aspect>): <description>`
- ✓ DO use the aspect name as the scope (see [commit-guide.md](docs/reference/commit-guide.md))

**STOP:** Present check results and ask: "All checks pass. Ready to commit?"

**CHECKPOINT:** Wait for explicit user approval before committing.

---

## Module Placement

**Choose the right location for new modules:**

| Type | Location | Example |
|------|----------|---------|
| Simple aspect | `modules/{name}.nix` | `modules/ssh.nix` |
| Complex feature | `modules/{feature}/` | `modules/nixvim/lsp.nix` |
| Host-specific | `modules/hosts/{hostname}/` | `modules/hosts/freya/hardware.nix` |
| Project option | `modules/nilfheim/+{name}.nix` | `modules/nilfheim/+user.nix` |
| Helper functions | `modules/lib/{name}.nix` | `modules/lib/nixvim.nix` |

**Naming:** Use aspect/purpose names (e.g., `ssh.nix`, `development-tools.nix`), not host names or implementation details.

**Details:** See [architecture.md](docs/reference/architecture.md) for module categories, import-tree behavior, and development rules.

---

## Quality Requirements

**Before ANY commit, all checks MUST pass:**

1. **Formatting:** `alejandra --check .` (or `alejandra .` to auto-fix)
2. **Linting:** `statix check .`
3. **Dead Code:** `deadnix --fail .`
4. **Build:** `nix flake check --impure` (when modifying system config)

**If checks fail:** See [troubleshooting.md](docs/reference/troubleshooting.md) for solutions.

---

## Commit Format

**Use Conventional Commits:**

```
<type>(<aspect>): <description>
```

**Common types:** feat, fix, refactor, style, docs, chore

**Scope:** Use aspect name (module name without `.nix`)

**Examples:**
- `feat(nixvim): add LSP support for Rust`
- `fix(hyprland): correct keybind for workspace switching`
- `refactor(desktop): reorganize aggregator imports`
- `chore(flake): update nixpkgs input`

**For details:** See [commit-guide.md](docs/reference/commit-guide.md) for extensive examples, breaking changes, and granularity guidance.

---

## Anti-Patterns to Avoid

**Don't do these (brief summary - see [anti-patterns.md](docs/reference/anti-patterns.md) for details):**

- ✗ **Host-centric organization** → Use aspect modules instead
- ✗ **Package-centric modules** → Group by purpose, only create modules with actual configuration
- ✗ **Manual import management** → Trust import-tree automatic loading
- ✗ **Interdependent feature modules** → Use aggregators or custom options
- ✗ **Skip workflow phases** → Always follow Explore → Plan → Code → Commit

---

## Quick Reference

### Phase Checkpoints

**After Explore:**
> "I've completed exploration. Findings: [summary]. Ready to move to planning phase?"

**After Plan:**
> "Here's my implementation plan:
> [TodoWrite output]
>
> Files to modify: [list]
> Files to create: [list]
>
> Does this plan look good? Should I proceed to implementation?"

**After Code:**
> "Implementation complete. Running quality checks..."
> [check results]
>
> "All checks pass. Summary of changes: [list]
>
> Ready to commit?"

### File Naming Pattern

- `{aspect}.nix` - Single-file aspect (e.g., `ssh.nix`)
- `{feature}/` - Multi-file feature (e.g., `nixvim/`)
- `+{option}.nix` - Custom project option (e.g., `+user.nix`)

---

## Additional Reference

**Read these documents when needed:**

- **[architecture.md](docs/reference/architecture.md)** - Project structure, import-tree internals, development rules
- **[commit-guide.md](docs/reference/commit-guide.md)** - Detailed commit examples, breaking changes, granularity
- **[anti-patterns.md](docs/reference/anti-patterns.md)** - What to avoid with detailed examples
- **[module-templates.md](docs/reference/module-templates.md)** - Code templates for different scenarios
- **[troubleshooting.md](docs/reference/troubleshooting.md)** - Error recovery, debugging, common issues

**When to read:**
- **Planning phase** → architecture.md, module-templates.md
- **Commit phase** → commit-guide.md
- **When errors occur** → troubleshooting.md
- **When unsure** → anti-patterns.md

---

## Resources

- **Dendritic Principles:** https://vic.github.io/dendrix/Dendritic.html
- **Reference Implementations:**
  - https://github.com/mightyiam/dendritic - Reference dendritic implementation by the pattern author
  - https://github.com/mightyiam/infra - Personal infrastructure using dendritic
  - https://github.com/drupol/infra - Another infrastructure example using dendritic
- **Flake Parts:** https://flake.parts
- **Conventional Commits:** https://www.conventionalcommits.org/

---

## Remember

1. **Always follow the four-phase workflow** with checkpoints
2. **Use Explore agent** for codebase investigation (not direct grep/glob)
3. **Use TodoWrite** to track tasks throughout implementation
4. **Wait for user approval** before moving to code phase
5. **`git add` new files immediately** - import-tree only loads git-tracked files
6. **Run all quality checks** before commit phase
7. **Wait for user confirmation** before making commits
8. **Use Conventional Commits** with aspect names as scope
9. **Preserve aspect-oriented organization** in all changes
10. **Ask questions** rather than making assumptions
