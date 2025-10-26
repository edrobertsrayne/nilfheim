# Anti-Patterns to Avoid

This document describes common anti-patterns that violate dendritic principles and should be avoided in Nilfheim configuration.

## Anti-Pattern 1: Host-Centric Organization

### ✗ DON'T DO THIS

```nix
# Bad: configuration scattered by host
modules/
  ├── freya/everything-for-freya.nix
  └── baldur/everything-for-baldur.nix
```

### Why This is Bad

- **Violates aspect-oriented principles** - Configuration is organized by machine, not by feature
- **Creates duplication** - Similar features on different hosts are duplicated instead of shared
- **Poor maintainability** - Updating a feature requires changes across multiple host files
- **Unclear dependencies** - Hard to understand what features depend on each other

### ✓ DO THIS INSTEAD

Use aspect modules with host-specific overrides only when truly needed:

```nix
# Good: aspect-oriented organization
modules/
  ├── ssh.nix                    # SSH config shared across all hosts
  ├── nixvim/                    # Editor config shared across all hosts
  ├── hosts/
  │   ├── freya/hardware.nix     # Only hardware-specific config
  │   └── baldur/hardware.nix    # Only hardware-specific config
```

**Principle:** Common functionality lives in aspect modules; hosts only contain what's truly unique to that machine (hardware, specific overrides).

---

## Anti-Pattern 2: Package-Centric Modules

### ✗ DON'T DO THIS

```nix
# Bad: module just installs a package
flake.modules.nixos.firefox = {
  environment.systemPackages = [ pkgs.firefox ];
};
```

### Why This is Bad

- **Too granular** - Creates module explosion (one module per package)
- **No configuration** - Package installation alone doesn't warrant a module
- **Hard to discover** - Hard to find which packages are installed where
- **Maintenance burden** - Every package needs its own file

### ✓ DO THIS INSTEAD

Group related packages by purpose or feature:

```nix
# Good: logical grouping by purpose
# modules/web-browsers.nix
flake.modules.nixos.webBrowsers = {
  environment.systemPackages = with pkgs; [
    firefox
    chromium
  ];

  # Plus any actual configuration
  programs.firefox.enable = true;
  programs.firefox.policies = { ... };
};

# Or include in a broader aspect
# modules/desktop.nix
flake.modules.nixos.desktop = {
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    # ... other desktop apps
  ];
};
```

**Principle:** Only create a dedicated module if there's actual configuration, not just package installation.

---

## Anti-Pattern 3: Manual Import Management

### ✗ DON'T DO THIS

```nix
# Bad: manually listing imports in flake.nix or other files
imports = [
  ./ssh.nix
  ./nix.nix
  ./networking.nix
  ./development.nix
];
```

### Why This is Bad

- **Defeats import-tree purpose** - The whole point is automatic discovery
- **Maintenance burden** - Must manually update imports list
- **Easy to forget** - Can forget to add new modules to the list
- **Redundant** - File organization already documents structure

### ✓ DO THIS INSTEAD

Trust the automatic loading; use file placement to control what's loaded:

```nix
# Good: let import-tree handle it
# Just create the file in the right place:
modules/
  ├── ssh.nix          # Automatically loaded
  ├── nix.nix          # Automatically loaded
  └── networking.nix   # Automatically loaded

# No manual imports needed!
```

**Special cases:**
- If you don't want a file loaded, prefix with `_` (e.g., `_draft.nix`)
- For host-specific modules, place in `modules/hosts/{hostname}/`

**Principle:** File location IS the import declaration. Use the filesystem as documentation.

---

## Anti-Pattern 4: Interdependent Feature Modules

### ✗ DON'T DO THIS

```nix
# Bad: feature-x depends on feature-y
# modules/feature-x.nix
flake.modules.nixos.feature-x = {
  imports = [ inputs.self.modules.nixos.feature-y ];

  # feature-x config
};
```

### Why This is Bad

- **Creates coupling** - Features become interdependent, can't be used separately
- **Breaks modularity** - Can't enable one without the other
- **Hidden dependencies** - Dependency structure is hidden inside modules
- **Hard to reason about** - Unclear which features are actually needed

### ✓ DO THIS INSTEAD

**Option 1: Use aggregator modules**

```nix
# Good: explicit aggregation
# modules/desktop.nix
flake.modules.nixos.desktop.imports = with inputs.self.modules.nixos; [
  feature-x
  feature-y
];
```

**Option 2: Use custom options for shared config**

```nix
# modules/nilfheim/+shared.nix
options.flake.nilfheim.shared.setting = lib.mkOption { ... };

# modules/feature-x.nix
flake.modules.nixos.feature-x = {
  # Use shared setting
  config.something = config.flake.nilfheim.shared.setting;
};

# modules/feature-y.nix
flake.modules.nixos.feature-y = {
  # Also use shared setting
  config.something = config.flake.nilfheim.shared.setting;
};
```

**Principle:** Features should be independent. Use aggregators to compose them, or custom options for shared configuration.

---

## Anti-Pattern 5: Skip Workflow Phases

### ✗ DON'T DO THIS

```nix
# Bad: jumping straight to code without exploration/planning
User: "Add feature X"
Agent: *immediately creates files without investigation*
```

### Why This is Bad

- **Leads to wrong implementations** - Don't understand existing patterns
- **Violates architectural principles** - Don't know where things should go
- **Creates technical debt** - Quick implementations often need refactoring
- **Misses context** - Don't understand why things are done certain ways

### ✓ DO THIS INSTEAD

Always follow the four-phase workflow:

1. **EXPLORE:** Investigate existing code, understand patterns
2. **PLAN:** Design solution, identify files to change, get approval
3. **CODE:** Implement according to approved plan
4. **COMMIT:** Verify quality, create commit after confirmation

**Example:**
```
User: "Add tailscale support"

Agent:
1. Explores existing networking modules
2. Plans: "I'll create modules/tailscale.nix with both NixOS and
   Home-Manager config, following the pattern from ssh.nix"
3. Waits for approval
4. Implements according to plan
5. Runs checks, waits for confirmation, then commits
```

**Principle:** Understanding comes before action. Plan before you code.

---

## Additional Anti-Patterns

### Anti-Pattern: Duplicate Configuration

**Don't:** Copy-paste configuration between modules
**Do:** Extract common config to custom options or shared functions

### Anti-Pattern: Hard-Coded Values

**Don't:** Hard-code usernames, paths, or host-specific values in aspect modules
**Do:** Use `flake.nilfheim.*` options or function parameters

### Anti-Pattern: Ignoring Quality Checks

**Don't:** Skip formatting, linting, or flake checks
**Do:** Run all checks before committing, fix issues immediately

### Anti-Pattern: Vague Commit Messages

**Don't:** `git commit -m "fix stuff"` or `git commit -m "update"`
**Do:** Follow Conventional Commits format with clear, descriptive messages

---

## Summary

**Core Principles to Follow:**

1. **Aspect-oriented, not host-centric** - Organize by feature, not by machine
2. **Purpose-driven modules** - Create modules for configuration, not just package installation
3. **Trust automation** - Let import-tree handle imports
4. **Independent features** - Use aggregators and custom options instead of cross-dependencies
5. **Follow the workflow** - Explore, Plan, Code, Commit - in that order
