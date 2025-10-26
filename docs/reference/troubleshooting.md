# Troubleshooting Guide

This document helps you diagnose and fix common issues when working with Nilfheim configuration.

## Quality Check Failures

### Alejandra Format Check Failed

**Symptom:**
```bash
$ alejandra --check .
💾 0 files would be changed
❌ 3 files would be changed
```

**Cause:** Code is not properly formatted according to Alejandra style.

**Solution:**
1. Run `alejandra .` (without --check) to auto-format all files
2. Review the changes with `git diff`
3. Re-run `alejandra --check .` to verify

**Prevention:** Run `alejandra .` before committing.

---

### Statix Check Failed

**Symptom:**
```bash
$ statix check .
[ERROR] modules/mymodule.nix:15:5: Empty pattern detected
[WARN] modules/other.nix:20:3: Deprecated syntax
```

**Cause:** Code contains linting issues or uses deprecated Nix patterns.

**Common issues:**
- Empty pattern bindings: `{ }:` instead of `{...}:`
- Unused variables in function signatures
- Deprecated Nix syntax
- Inefficient patterns

**Solution:**
1. Read the error message carefully - it shows file, line, and column
2. Use `Read` tool to view the problematic file at the specified line
3. Fix the issue according to statix suggestion
4. Re-run `statix check .`

**Auto-fix (some issues):**
```bash
statix fix .  # Attempts to auto-fix issues
```

---

### Deadnix Check Failed

**Symptom:**
```bash
$ deadnix --fail .
modules/mymodule.nix:10:5: Unused variable 'pkgs'
modules/other.nix:15:3: Unused variable 'config'
```

**Cause:** Code declares variables that are never used.

**Solution:**
1. Remove unused variables from function signatures
2. Or use them if they were supposed to be used
3. Re-run `deadnix --fail .`

**Example fix:**
```nix
# Before (unused pkgs)
{ inputs, config, lib, pkgs, ... }: {
  flake.modules.nixos.myModule = {
    services.something.enable = true;
  };
}

# After (removed pkgs)
{ inputs, config, lib, ... }: {
  flake.modules.nixos.myModule = {
    services.something.enable = true;
  };
}
```

**Prevention:** Only include parameters you actually use.

---

### Nix Flake Check Failed

**Symptom:**
```bash
$ nix flake check --impure
error: attribute 'modules.nixos.myModule' already defined at ...
```

**See Import-Tree Issues section below** - this is usually related to import-tree not seeing files.

---

## Import-Tree Issues

### Error: Option Defined Multiple Times

**Symptom:**
```
error: The option `flake.modules.nixos.myFeature' is defined multiple times
```

**Cause:** Usually means you created a new `.nix` file but **forgot to `git add` it**.

**Why this happens:**
1. You create `modules/myfeature.nix` defining `flake.modules.nixos.myFeature`
2. You forget to `git add` it
3. Import-tree doesn't see the new file (only loads tracked files)
4. NixOS tries to auto-generate the option
5. Conflict: auto-generated + your definition = duplicate

**Solution:**
```bash
# Add the new file to git
git add modules/myfeature.nix

# Now import-tree can see it
nix flake check --impure
```

**Always remember:** Import-tree only loads git-tracked files!

---

### Error: File Not Found / Module Not Loaded

**Symptom:**
- Features don't work even though you created the module
- `nix flake check` passes but configuration has no effect
- References to your module fail with "attribute missing"

**Cause:** File not tracked by git, so import-tree ignores it.

**Solution:**
```bash
# Check if file is tracked
git status

# If untracked, add it
git add modules/path/to/file.nix

# Verify it's now staged
git status
```

**Verification:**
```bash
# This should now work
nix flake check --impure
```

---

### Error: Infinite Recursion

**Symptom:**
```
error: infinite recursion encountered
```

**Common causes:**
1. Module references itself circularly
2. Two modules depend on each other's options
3. Option default value references the option itself

**Solution:**
1. Review recent changes for circular dependencies
2. Check if you're using `lib.mkIf` or `lib.mkDefault` appropriately
3. Ensure modules don't import each other directly
4. Use aggregator pattern instead of cross-module imports

**Example problem:**
```nix
# BAD: Circular dependency
# modules/feature-a.nix
imports = [ inputs.self.modules.nixos.feature-b ];

# modules/feature-b.nix
imports = [ inputs.self.modules.nixos.feature-a ];
```

**Fix:** Use aggregator or remove imports.

---

## Build Failures

### Error: Package Not Found

**Symptom:**
```
error: attribute 'mypackage' missing
```

**Cause:** Package doesn't exist in nixpkgs or is misspelled.

**Solution:**
1. Search for the package: `nix search nixpkgs mypackage`
2. Check package name is correct
3. Verify package exists in your nixpkgs version
4. If package is in unstable but not stable, ensure you're using unstable

**Verification:**
```bash
# Search for package
nix search nixpkgs firefox

# Or search online
# https://search.nixos.org/packages
```

---

### Error: Module Not Found in Imports

**Symptom:**
```
error: getting status of '/nix/store/.../modules/nonexistent.nix': No such file or directory
```

**Cause:** Manual import references file that doesn't exist.

**Solution:**
1. Check if file path is correct
2. Ensure file exists and is tracked by git
3. Consider: do you need manual import? (Usually import-tree handles this)

---

## Common Workflow Issues

### Stuck in Exploration Phase

**Symptom:** Can't find where to implement feature, unsure of approach.

**Solution:**
1. Use `Task` tool with `subagent_type=Explore` for broad searches
2. Look for similar existing features
3. Check [architecture.md](architecture.md) for module placement rules
4. Check [module-templates.md](module-templates.md) for examples
5. Ask user for clarification if requirements are unclear

**Questions to ask yourself:**
- Is there already a similar module?
- Where would this logically fit?
- Does it need system config, user config, or both?

---

### Uncertain About Module Placement

**Symptom:** Don't know where to create the new module.

**Solution:** Use the decision tree from [architecture.md](architecture.md):

| Type | Location |
|------|----------|
| Project setting | `modules/nilfheim/+{name}.nix` |
| Helper function | `modules/lib/{name}.nix` |
| Host-specific | `modules/hosts/{hostname}/` |
| Simple aspect | `modules/{name}.nix` |
| Complex feature | `modules/{feature}/` |

**Still unsure?** Ask user which approach they prefer.

---

### Plan Not Approved

**Symptom:** User rejects proposed plan.

**Solution:**
1. Ask clarifying questions about what's wrong
2. Revise plan based on feedback
3. Update TodoWrite list
4. Present revised plan
5. Don't proceed until approval

**Never:** Start implementing without approval.

---

### Tests or Build Failing After Implementation

**Symptom:** Code is written but quality checks fail.

**Solution:**
1. **Don't mark task as completed** - Keep it in_progress
2. Fix the failing checks (see Quality Check Failures section above)
3. Re-run checks until all pass
4. Only then mark task completed and ask user for commit approval

**Remember:** Completed means fully done and all checks passing, not just "code written."

---

## Debugging Strategies

### Strategy 1: Incremental Testing

When making large changes:
1. Implement one module at a time
2. Run `nix flake check --impure` after each module
3. Fix issues immediately before moving to next module
4. This isolates which change caused which error

### Strategy 2: Read Error Messages Carefully

Nix error messages often include:
- File path and line number
- What was expected vs what was found
- Suggestion for fix

**Don't just skim** - read the full error message.

### Strategy 3: Use Git to Narrow Down Issues

If something broke after recent changes:
```bash
# See what changed
git diff

# Temporarily undo changes to test
git stash

# Test if issue is gone
nix flake check --impure

# Restore changes
git stash pop
```

### Strategy 4: Check Recent Commits

Look at similar working modules:
```bash
# Find similar modules
ls modules/*.nix

# Read a working module for reference
# Use Read tool on a similar module
```

### Strategy 5: Ask User for Help

When truly stuck:
1. Explain what you've tried
2. Share the error message
3. Describe what you think the issue might be
4. Ask for guidance

**Don't:** Silently struggle or mark tasks completed when blocked.

---

## When to Ask User

### Always ask when:
1. **Ambiguous requirements** - Not clear what user wants
2. **Multiple valid approaches** - User should choose direction
3. **Breaking changes needed** - User should approve
4. **Stuck despite troubleshooting** - After trying solutions here
5. **Plan rejected** - Need clarification on what to change

### Don't ask when:
1. **Standard formatting issues** - Just run alejandra
2. **Clear quality check failures** - Fix according to error message
3. **Obvious typos** - Just fix them
4. **Missing git add** - Just add the file

**Principle:** Ask when you need human judgment; fix when the solution is clear.

---

## Recovery Checklist

When something goes wrong, work through this checklist:

- [ ] Read the full error message carefully
- [ ] Check if new files need `git add`
- [ ] Run quality checks (alejandra, statix, deadnix)
- [ ] Review recent changes with `git diff`
- [ ] Consult relevant reference doc (architecture, templates, anti-patterns)
- [ ] Try incremental testing (undo changes, test, reapply)
- [ ] If still stuck, ask user with full context

## Prevention Checklist

Before committing:

- [ ] All new `.nix` files are git-added
- [ ] `alejandra --check .` passes
- [ ] `statix check .` passes
- [ ] `deadnix --fail .` passes
- [ ] `nix flake check --impure` passes (if applicable)
- [ ] All todos marked completed
- [ ] Commit message follows Conventional Commits format
