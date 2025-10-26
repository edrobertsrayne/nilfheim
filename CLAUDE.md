# Nilfheim NixOS Configuration - AI Agent Guidelines

This NixOS configuration follows **dendritic principles** for aspect-oriented, modular configuration management. All AI agents must follow the workflow and rules below.

## Mandatory Workflow: Explore → Plan → Code → Commit

Every task MUST follow these four phases with explicit checkpoints. **DO NOT skip phases or checkpoints.**

### Phase 1: EXPLORE (Read-Only)

**Goal:** Understand the codebase and gather context.

**Actions:**
- Use Task tool with `subagent_type=Explore` for codebase investigation
- Read relevant files, documentation, and existing implementations
- Search for similar patterns or related features
- Understand the scope and impact of changes

**RULES:**
- ✗ DO NOT write, edit, or create any files
- ✗ DO NOT propose solutions or implementation details
- ✗ DO NOT execute Bash commands that modify state
- ✓ DO use Read, Grep, Glob, and Explore agents
- ✓ DO ask clarifying questions if requirements are unclear

**STOP:** After exploration, present findings and ask: "Ready to move to planning phase?"

---

### Phase 2: PLAN (Design-Only)

**Goal:** Design a solution that preserves dendritic architecture.

**Actions:**
- Propose an implementation approach
- Identify which modules need changes
- Determine if new modules are needed (and where they belong)
- Plan testing and verification strategy
- Use TodoWrite to document implementation steps

**RULES:**
- ✗ DO NOT write, edit, or create any files
- ✗ DO NOT start implementing the solution
- ✓ DO document the plan clearly
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
- Verify changes align with dendritic principles
- Test changes incrementally if possible

**RULES:**
- ✓ DO implement only what was approved in the plan
- ✓ DO ask for guidance if you discover new issues
- ✗ DO NOT create git commits yet
- ✗ DO NOT push changes
- ✗ DO NOT deviate from the approved plan without asking

**STOP:** After implementation, run quality checks (next section).

---

### Phase 4: COMMIT (Finalize)

**Goal:** Verify quality and create commits.

**REQUIRED CHECKS (All must pass):**

```bash
# Format check
alejandra --check .

# Linting
statix check .
deadnix --fail .

# Build verification (if applicable)
nix flake check --impure
```

**Actions:**
1. Run all quality checks above
2. Fix any issues found
3. Present a summary of all changes made
4. Create git commit only after user confirmation

**RULES:**
- ✗ DO NOT commit until ALL checks pass
- ✗ DO NOT commit until user confirms they're happy with changes
- ✓ DO use descriptive commit messages following Conventional Commits
- ✓ DO use the aspect name as the scope

**STOP:** Present check results and ask: "All checks pass. Ready to commit?"

**CHECKPOINT:** Wait for explicit user approval before committing.

---

## Project Architecture

### Overview

- **Base:** Flake-parts with automatic module loading via `import-tree`
- **Pattern:** Aspect-oriented configuration (dendritic)
- **Organization:** Feature modules, aggregators, host-specific configs

### Directory Structure

```
nilfheim/
├── flake.nix                    # Entry point (minimal, just dependencies)
├── modules/
│   ├── flake/                   # Flake-parts configuration
│   ├── nilfheim/                # Custom project options (+user.nix, +theme.nix)
│   ├── hosts/                   # Host-specific configurations
│   │   └── {hostname}/          # Per-host modules
│   ├── lib/                     # Custom library functions
│   ├── {feature}/               # Feature-specific modules (nixvim/, hyprland/, waybar/)
│   └── {aspect}.nix             # Root-level aspect modules (ssh.nix, nix.nix, etc.)
└── secrets/                     # Secrets management
```

### Module Categories

1. **NixOS Modules:** `flake.modules.nixos.*` - System-level configuration
2. **Home-Manager Modules:** `flake.modules.homeManager.*` - User-level configuration
3. **Flake Options:** `flake.nilfheim.*` - Project-wide settings

### Key Concepts

- **Aspect Modules:** Each `.nix` file configures one aspect across multiple contexts
- **Aggregators:** Modules that import related features (e.g., `desktop.nix`)
- **No Manual Imports:** `import-tree` auto-loads modules; file location = documentation

---

## Development Rules

### Creating New Features

**Rule 1: Aspect-Oriented Naming**
- ✓ Name files by **purpose/feature**, not implementation
- ✓ Examples: `ai-integration.nix`, `development-tools.nix`, `wayland-clipboard.nix`
- ✗ Avoid: `my-laptop.nix`, `package-list.nix`, `freya-specific.nix`

**Rule 2: Module Placement**

Choose the right location:

| Type | Location | Example |
|------|----------|---------|
| Simple aspect | `modules/{name}.nix` | `modules/ssh.nix` |
| Complex feature | `modules/{feature}/` | `modules/nixvim/lsp.nix` |
| Host-specific | `modules/hosts/{hostname}/` | `modules/hosts/freya/hardware.nix` |
| Project option | `modules/nilfheim/+{name}.nix` | `modules/nilfheim/+user.nix` |
| Helper functions | `modules/lib/{name}.nix` | `modules/lib/nixvim.nix` |

**Rule 3: Aggregator Pattern**

For related features that are commonly used together:
1. Create individual feature modules first
2. Create an aggregator that imports them
3. Example: `desktop.nix` aggregates `hyprland`, `greetd`, `nixvim`, `waybar`

```nix
# Good: aggregator pattern
flake.modules.nixos.desktop.imports = with inputs.self.modules.nixos; [
  hyprland
  greetd
];
```

**Rule 4: Multi-Context Configuration**

When a feature needs both NixOS and Home-Manager config:

```nix
# Good: one file, multiple contexts
{ inputs, ... }: {
  flake.modules.nixos.myFeature = {
    # NixOS system config
    services.myService.enable = true;
  };

  flake.modules.homeManager.myFeature = {
    # Home-manager user config
    programs.myProgram.enable = true;
  };
}
```

**Rule 5: Custom Options**

Use `flake.nilfheim.*` for project-wide settings:

```nix
# Define in modules/nilfheim/+feature.nix
options.flake.nilfheim.feature = {
  setting = lib.mkOption { ... };
};

# Reference in other modules
config.flake.modules.nixos.something = {
  value = config.flake.nilfheim.feature.setting;
};
```

**Rule 6: Avoid Manual Imports**

- ✗ DO NOT add imports in `flake.nix`
- ✓ DO let `import-tree` discover modules automatically
- ✓ DO use file organization as documentation

---

## Quality Requirements

### Before ANY Commit

All three checks MUST pass:

1. **Formatting:** `alejandra --check .` (or `alejandra .` to fix)
2. **Linting:** `statix check .`
3. **Dead Code:** `deadnix --fail .`

### Additional Verification

When modifying system config:
```bash
# Check flake validity
nix flake check --impure

# Test build (if applicable)
nixos-rebuild build --flake .#hostname
```

### Incremental Testing

For significant changes:
1. Test individual modules first
2. Verify aggregators work correctly
3. Build full system configuration
4. Test on actual hardware (if needed)

---

## Anti-Patterns

### ✗ DO NOT: Host-Centric Organization

```nix
# Bad: configuration scattered by host
modules/
  ├── freya/everything-for-freya.nix
  └── baldur/everything-for-baldur.nix
```

**Why:** Violates aspect-oriented principles, creates duplication.

**Instead:** Use aspect modules with host-specific overrides only when needed.

---

### ✗ DO NOT: Package-Centric Modules

```nix
# Bad: module just installs a package
flake.modules.nixos.firefox = {
  environment.systemPackages = [ pkgs.firefox ];
};
```

**Why:** Too granular, creates module explosion.

**Instead:** Group related packages by purpose (e.g., `web-browsers.nix`, `desktop.nix`).

---

### ✗ DO NOT: Manual Import Management

```nix
# Bad: manually listing imports
imports = [
  ./ssh.nix
  ./nix.nix
  ./networking.nix
];
```

**Why:** `import-tree` handles this automatically.

**Instead:** Trust the automatic loading; use file placement to control what's loaded.

---

### ✗ DO NOT: Interdependent Feature Modules

```nix
# Bad: feature-x depends on feature-y
flake.modules.nixos.feature-x = {
  imports = [ inputs.self.modules.nixos.feature-y ];
};
```

**Why:** Creates coupling, breaks modularity.

**Instead:** Use aggregator modules or custom options for shared config.

---

### ✗ DO NOT: Skip Workflow Phases

```nix
# Bad: jumping straight to code without exploration/planning
User: "Add feature X"
Agent: *immediately creates files*
```

**Why:** Leads to wrong implementations, architectural violations.

**Instead:** Always follow Explore → Plan → Code → Commit.

---

## Commit Guidelines

### Conventional Commits Format

All commits MUST follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<aspect>): <description>

[optional body]

[optional footer(s)]
```

### Types

- **feat:** New feature or capability
- **fix:** Bug fix
- **refactor:** Code change that neither fixes a bug nor adds a feature
- **style:** Formatting changes (alejandra, whitespace, etc.)
- **docs:** Documentation only changes
- **chore:** Maintenance tasks, dependency updates
- **test:** Adding or updating tests
- **perf:** Performance improvements

### Scope: Use Aspect Names

**The scope MUST be the aspect name** (module name without `.nix`):

- ✓ `feat(nixvim): add telescope file browser`
- ✓ `fix(hyprland): correct keybind for workspace switching`
- ✓ `refactor(desktop): reorganize aggregator imports`
- ✓ `feat(ssh): enable agent forwarding`
- ✓ `chore(flake): update nixpkgs input`
- ✓ `feat(tailscale): configure exit node`
- ✓ `fix(waybar): resolve CPU usage display`

For changes to multiple related aspects, use the aggregator or primary aspect:
- ✓ `feat(desktop): add clipboard manager and notification daemon`

For project-wide changes:
- ✓ `chore(flake): update all inputs`
- ✓ `docs(readme): update installation instructions`

### Examples

```
feat(nixvim): add LSP support for Rust

Configure rust-analyzer with recommended settings
and add keybindings for common LSP operations.
```

```
fix(hyprland): resolve monitor configuration issue

The previous configuration caused display flickering
on external monitors. Updated to use explicit mode settings.
```

```
refactor(desktop): split into smaller aspect modules

Breaks monolithic desktop.nix into separate wayland.nix,
compositor.nix, and terminal.nix modules following
dendritic principles.
```

```
chore(flake): update nixpkgs to latest unstable
```

### Breaking Changes

For breaking changes, add `!` after the scope and explain in footer:

```
refactor(nilfheim)!: rename user option structure

BREAKING CHANGE: flake.nilfheim.user.name is now
flake.nilfheim.user.username for consistency.
Update host configurations accordingly.
```

---

## Quick Reference

### Starting a New Task

1. **Explore:** "Let me investigate the codebase first..."
2. **Plan:** "Here's my proposed approach... Does this look good?"
3. **Code:** "I'll implement the approved plan..."
4. **Commit:** "All checks pass. Ready to commit?"

### File Naming Pattern

- `{aspect}.nix` - Single-file aspect (e.g., `ssh.nix`, `tailscale.nix`)
- `{feature}/` - Multi-file feature (e.g., `nixvim/`, `hyprland/`)
- `+{option}.nix` - Custom project option (e.g., `+user.nix`, `+theme.nix`)

### Module Structure Template

```nix
{ inputs, config, lib, pkgs, ... }: {
  # NixOS config (if needed)
  flake.modules.nixos.myAspect = {
    # system-level config
  };

  # Home-Manager config (if needed)
  flake.modules.homeManager.myAspect = {
    # user-level config
  };
}
```

### Commit Message Template

```
<type>(<aspect>): <short description>

[Why this change was needed]
[What was changed at a high level]
[Any important implementation notes]
```

---

## Resources

- **Dendritic Principles:** https://vic.github.io/dendrix/Dendritic.html
- **Flake Parts:** https://flake.parts
- **Conventional Commits:** https://www.conventionalcommits.org/
- **Reference Configs:**
  - https://github.com/vic/dendrix
  - https://github.com/GaetanLepage/nix-config

---

## Remember

1. **Always follow the four-phase workflow** with checkpoints
2. **Wait for user approval** before moving to code phase
3. **Wait for user confirmation** before making commits
4. **Run all quality checks** before commit phase
5. **Use Conventional Commits with aspect names as scope**
6. **Preserve aspect-oriented organization** in all changes
7. **Ask questions** rather than making assumptions
