---
description: Check linting, fix errors, and commit changes with appropriate message
---

You are tasked with committing the current state of the repository.

**Your task:**

1. **Check git status** to see what has changed:
   ```bash
   git status
   git diff --stat
   ```

2. **Fix formatting and linting issues:**
   ```bash
   alejandra .  # Auto-fix formatting
   statix check .  # Check linting
   deadnix --fail .  # Check for dead code
   ```

3. **Review the changes** to understand what was modified:
   ```bash
   git diff
   ```

4. **Stage all changes:**
   ```bash
   git add -A
   ```

5. **Analyze the changes** and determine:
   - What type of change is this? (feat, fix, refactor, chore, docs, style, etc.)
   - What scope/aspect is affected? (the module or area being changed)
   - What is a clear, concise description of the change?

6. **Create an appropriate conventional commit message** following this format:
   ```
   <type>(<scope>): <description>

   <optional body if the change is complex>

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude <noreply@anthropic.com>
   ```

   **Conventional commit types:**
   - `feat`: New feature
   - `fix`: Bug fix
   - `refactor`: Code restructuring without functional changes
   - `chore`: Maintenance tasks (dependencies, config)
   - `docs`: Documentation only
   - `style`: Code style/formatting changes
   - `test`: Adding or updating tests
   - `perf`: Performance improvements

7. **Commit with the generated message:**
   ```bash
   git commit -m "<your message>"
   ```

8. **Report back:**
   - Files changed summary
   - Brief description of what changed
   - The commit message used
   - Commit hash
   - Any linting issues found/fixed

**Important:**
- Be concise but descriptive in commit messages
- Use the aspect name as the scope when possible (e.g., `refactor(zsh):`, `feat(desktop):`)
- If multiple aspects are changed, use a broader scope or omit the scope
- Always include the Claude Code footer
