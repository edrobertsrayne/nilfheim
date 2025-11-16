# Commit Guidelines

All commits for Niflheim MUST follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

## Conventional Commits Format

```
<type>(<aspect>): <description>

[optional body]

[optional footer(s)]
```

## Commit Types

- **feat:** New feature or capability
- **fix:** Bug fix
- **refactor:** Code change that neither fixes a bug nor adds a feature
- **style:** Formatting changes (alejandra, whitespace, etc.)
- **docs:** Documentation only changes
- **chore:** Maintenance tasks, dependency updates
- **test:** Adding or updating tests
- **perf:** Performance improvements

## Scope: Use Aspect Names

**The scope MUST be the aspect name** (module name without `.nix`):

**Good examples:**
- `feat(nixvim): add telescope file browser`
- `fix(hyprland): correct keybind for workspace switching`
- `feat(yabai): add macOS window manager with skhd keybinds`
- `refactor(desktop): reorganize aggregator imports`
- `feat(ssh): enable agent forwarding`
- `chore(flake): update nixpkgs input`
- `feat(tailscale): configure exit node`
- `fix(waybar): resolve CPU usage display`

For changes to multiple related aspects, use the aggregator or primary aspect:
- `feat(desktop): add clipboard manager and notification daemon`

For project-wide changes:
- `chore(flake): update all inputs`
- `docs(readme): update installation instructions`

## Detailed Examples

### Example 1: New Feature

```
feat(nixvim): add LSP support for Rust

Configure rust-analyzer with recommended settings
and add keybindings for common LSP operations.
```

**When to use:** Adding new functionality to an aspect module.

---

### Example 2: Bug Fix

```
fix(hyprland): resolve monitor configuration issue

The previous configuration caused display flickering
on external monitors. Updated to use explicit mode settings.
```

**When to use:** Fixing broken behavior or errors.

---

### Example 3: Refactoring

```
refactor(desktop): split into smaller aspect modules

Breaks monolithic desktop.nix into separate wayland.nix,
compositor.nix, and terminal.nix modules following
dendritic principles.
```

**When to use:** Reorganizing code without changing behavior.

---

### Example 4: Simple Maintenance

```
chore(flake): update nixpkgs to latest unstable
```

**When to use:** Routine maintenance, dependency updates.

---

### Example 5: Documentation

```
docs(claude): add troubleshooting guide

Add new reference document for common error recovery
scenarios and debugging steps.
```

**When to use:** Changes to documentation only.

---

### Example 6: Multiple Related Changes

```
feat(desktop): enhance clipboard and notification support

- Add wl-clipboard for Wayland clipboard management
- Configure mako notification daemon
- Add keybindings for clipboard history

Both features are part of the desktop user experience
and are commonly used together.
```

**When to use:** Multiple changes to related functionality within the same aspect.

## Breaking Changes

For breaking changes, add `!` after the scope and explain in footer:

```
refactor(niflheim)!: rename user option structure

BREAKING CHANGE: flake.niflheim.user.name is now
flake.niflheim.user.username for consistency.
Update host configurations accordingly.
```

**When to use:** Changes that require updates to existing configurations or break compatibility.

## Commit Granularity

### Prefer: One Commit Per Logical Change

**Good:**
- One commit per feature (even if it touches multiple files)
- One commit per bug fix
- One commit per refactoring effort

**Avoid:**
- Multiple unrelated aspects in one commit
- Splitting one feature across multiple commits (unless very large)

### When to Split Commits

1. **Multiple independent features** - Create separate `feat` commits
2. **Refactor + new feature** - Refactor commit first, then feature commit
3. **User requests "also fix X while you're at it"** - Ask user: "One commit or two?"

### Default Strategy

Unless the task is very large or complex, aim for **one clean commit per task**.

## Multi-Aspect Changes

When changes span multiple aspects:

**Option 1: Use the primary aspect**
```
feat(hyprland): add clipboard and screenshot integration

Updates desktop.nix aggregator to include new utilities.
```

**Option 2: Use the aggregator**
```
feat(desktop): add clipboard and screenshot tools

Configures wl-clipboard, grim, and slurp for Wayland
desktop environment.
```

**Choose based on:** Which aspect is most central to the change.

## Tips

1. **First line is most important** - Make it clear and descriptive
2. **Body explains why** - Focus on motivation and context, not what (code shows what)
3. **Keep first line under 72 characters** - For better git log readability
4. **Use imperative mood** - "add feature" not "added feature" or "adds feature"
5. **Reference issues if applicable** - "Fixes #123" in footer

## Resources

- **Conventional Commits Spec:** https://www.conventionalcommits.org/
- **Semantic Versioning:** https://semver.org/ (used with conventional commits for versioning)
