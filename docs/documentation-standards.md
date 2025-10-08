# Documentation Standards

Comprehensive guidelines for creating and maintaining documentation in the Nilfheim project.

## Overview

Good documentation is essential for project maintainability and collaboration. This document establishes standards for consistency, clarity, and completeness across all Nilfheim documentation.

**Guiding Principles:**
- **Clarity over cleverness** - Simple, direct language
- **Examples over theory** - Show, don't just tell
- **Maintenance-friendly** - Easy to update and validate
- **User-focused** - Written for the reader, not the author

---

## Documentation Structure

### Document Categories

Nilfheim documentation is organized into three primary categories:

#### 1. Architecture & Development
- **Purpose**: Explain system design and development practices
- **Audience**: Developers, contributors
- **Examples**: CLAUDE.md, service-module-template.md
- **Characteristics**: Conceptual, pattern-focused, "why" explanations

#### 2. Operations
- **Purpose**: Guide day-to-day system operations
- **Audience**: System administrators, operators
- **Examples**: backup-operations.md, monitoring.md, troubleshooting.md
- **Characteristics**: Procedural, command-focused, troubleshooting-oriented

#### 3. Project Management
- **Purpose**: Document infrastructure and planning
- **Audience**: All stakeholders
- **Examples**: database-services.md, monitoring-dashboards.md, TODO.md
- **Characteristics**: Reference material, specifications, roadmaps

### File Organization

```
nilfheim/
├── README.md                      # Project overview (for new users)
├── CLAUDE.md                      # Architecture & development guide (for AI/developers)
├── TODO.md                        # Project roadmap
└── docs/
    ├── README.md                  # Documentation index
    ├── documentation-standards.md # This file
    ├── backup-operations.md       # Operational guide
    ├── monitoring.md              # Operational guide
    ├── troubleshooting.md         # Operational guide
    ├── command-reference.md       # Reference material
    ├── database-services.md       # Infrastructure documentation
    ├── monitoring-dashboards.md   # Infrastructure documentation
    └── service-module-template.md # Development template
```

---

## Writing Standards

### Document Structure

Every documentation file should follow this structure:

```markdown
# Document Title

Brief description of document purpose (1-2 sentences).

## Overview

High-level introduction (what, why, who).

## Main Sections

[Content organized by topic]

## Additional Resources

[Links to related documentation]
```

### Heading Hierarchy

- **H1 (`#`)**: Document title only (one per document)
- **H2 (`##`)**: Major sections
- **H3 (`###`)**: Subsections
- **H4 (`####`)**: Sub-subsections (use sparingly)
- **H5+**: Avoid; restructure if needed

**Example:**
```markdown
# Title                    # H1 - Document title
## Overview                # H2 - Major section
### Getting Started        # H3 - Subsection
#### Prerequisites         # H4 - Sub-subsection (if necessary)
```

### Writing Style

#### Tone and Voice
- **Active voice**: "Run the command" (not "The command should be run")
- **Present tense**: "The system creates" (not "The system will create")
- **Direct address**: "You can" (not "Users can" or "One can")
- **Concise**: Eliminate unnecessary words
- **Professional**: Avoid colloquialisms and jargon without explanation

#### Formatting Conventions

**Bold** for emphasis and UI elements:
```markdown
Click the **Save** button.
The **hostname** parameter is required.
```

*Italic* for introducing new terms:
```markdown
A *flake* is a reproducible Nix package specification.
```

`Code formatting` for:
- Commands: `` `just check` ``
- File paths: `` `lib/constants.nix` ``
- Code elements: `` `mkOption` ``
- Configuration values: `` `enable = true` ``

**Lists** - Use consistent formatting:
```markdown
# Unordered lists for non-sequential items
- First item
- Second item
- Third item

# Ordered lists for sequential steps
1. First step
2. Second step
3. Third step
```

---

## Code Examples

### Command Examples

Always provide complete, working commands:

```bash
# ✅ Good - Complete, runnable command
sudo nixos-rebuild switch --flake .#thor

# ❌ Bad - Incomplete or vague
nixos-rebuild switch (with appropriate flags)
```

**Include context:**
```bash
# Check service status
systemctl status servicename.service

# View recent logs
journalctl -u servicename.service --since "1 hour ago"
```

### Configuration Examples

Provide realistic, tested examples:

```nix
# ✅ Good - Realistic example
services.nginx.virtualHosts."example.domain.com" = {
  locations."/" = {
    proxyPass = "http://127.0.0.1:8080";
    proxyWebsockets = true;
  };
};

# ❌ Bad - Placeholder-heavy example
services.nginx.virtualHosts."<your-domain>" = {
  locations."<path>" = {
    proxyPass = "<url>";
  };
};
```

### Code Block Formatting

Always specify language for syntax highlighting:

````markdown
```bash
# Bash commands
just check
```

```nix
# Nix configuration
services.example.enable = true;
```

```json
# JSON data
{"key": "value"}
```
````

---

## Documentation Types

### Architecture Documentation (CLAUDE.md)

**Purpose**: Explain system design for AI assistants and developers

**Structure:**
1. Architecture Overview - System topology, module organization, design decisions
2. Development Guide - Workflow, quality requirements
3. Configuration Patterns - Service development, security architecture
4. Project Conventions - File organization, naming, critical constraints
5. Quick Reference - Essential commands and locations
6. Additional Resources - Links to detailed documentation

**Characteristics:**
- Focus on "what" and "why", not "how"
- Explain architecture and patterns
- Developer-centric perspective
- Minimize step-by-step procedures (link to operational docs instead)

### Operational Documentation

**Purpose**: Guide system operations and troubleshooting

**Required Sections:**
- **Overview** - What this document covers
- **Prerequisites** - What you need before starting
- **Procedures** - Step-by-step instructions
- **Troubleshooting** - Common issues and solutions
- **Reference** - Quick lookup tables, commands

**Examples:**
- backup-operations.md
- monitoring.md
- troubleshooting.md
- command-reference.md

### Service Documentation

**Purpose**: Document specific service configuration and integration

**Required Sections:**
- **Overview** - Service purpose and capabilities
- **Configuration** - Setup and options
- **Integration** - How it connects with other services
- **Monitoring** - Health checks and metrics
- **Troubleshooting** - Service-specific issues

**Examples:**
- database-services.md
- monitoring-dashboards.md

### Development Templates

**Purpose**: Provide standardized patterns for development

**Required Sections:**
- **Template** - Complete code example
- **Patterns** - Common usage patterns
- **Best Practices** - Guidelines and conventions
- **Examples** - Real-world implementations

**Examples:**
- service-module-template.md

---

## Cross-Referencing

### Linking Between Documents

Use relative paths for internal links:

```markdown
# ✅ Good - Relative paths
See [CLAUDE.md](../CLAUDE.md) for architecture details.
See [Backup Operations](backup-operations.md) for restore procedures.

# ❌ Bad - Absolute paths or external URLs
See https://github.com/user/repo/blob/main/CLAUDE.md
```

### Section Anchors

Link to specific sections using anchors:

```markdown
See [CLAUDE.md Architecture Overview](../CLAUDE.md#architecture-overview)
See [Adding a New Service](../CLAUDE.md#adding-a-new-service)
```

**Note**: GitHub automatically creates anchors from headers (lowercase, hyphens for spaces).

### When to Cross-Reference

**Always link when:**
- Referring to another document's content
- Mentioning a procedure documented elsewhere
- Citing related configuration examples

**Example:**
```markdown
For complete backup recovery procedures, see
[Backup Operations](backup-operations.md#backup-recovery).

Configure the service following patterns in
[CLAUDE.md Configuration Patterns](../CLAUDE.md#configuration-patterns).
```

---

## Maintenance Guidelines

### When to Update Documentation

Update documentation when:
1. **Adding new features** - Document new services, configurations, commands
2. **Changing behavior** - Update affected documentation immediately
3. **Fixing bugs** - Update troubleshooting sections with solutions
4. **Refactoring** - Ensure examples and references remain accurate
5. **Deprecating features** - Mark as deprecated, provide migration path

### Validation Checklist

Before committing documentation changes:

- [ ] All code examples are tested and working
- [ ] Internal links are valid and not broken
- [ ] Command examples include necessary context
- [ ] Configuration examples are complete and realistic
- [ ] Spelling and grammar are correct
- [ ] Formatting is consistent with standards
- [ ] Cross-references are accurate

### Review Process

1. **Self-review**: Read through your changes as if you're a new user
2. **Test examples**: Run all commands and verify configurations
3. **Check links**: Verify all cross-references work
4. **Validate format**: Ensure consistent formatting and structure
5. **Commit**: Include "docs:" prefix in commit message

**Commit format:**
```
docs(backup): add repository maintenance section
docs(monitoring): update Loki query examples
docs: create documentation standards guide
```

---

## Common Patterns

### Documenting New Services

When adding a new service, update:

1. **Service module** - Inline comments for complex logic
2. **CLAUDE.md** - If service introduces new patterns or abstractions
3. **docs/README.md** - Add to appropriate category
4. **README.md** - Add to capabilities section (if user-facing)
5. **TODO.md** - Remove from TODO if applicable

### Documenting Configuration Changes

When changing configuration:

1. **Update affected examples** - Search docs for related code
2. **Update troubleshooting** - Add new issues if introduced
3. **Update architecture docs** - If design patterns change
4. **Update command reference** - If commands change

### Deprecation Documentation

When deprecating features:

```markdown
## Service Name

> **⚠️ DEPRECATED**: This service is deprecated as of 2024-01-01.
> Use [New Service](new-service.md) instead.
> Migration guide: [Migration](migration.md)

[Existing documentation for reference]
```

---

## Templates

### New Documentation Template

```markdown
# Document Title

Brief description of what this document covers (1-2 sentences).

## Overview

Provide context:
- What is this?
- Why is it needed?
- Who is this for?

## [Main Section]

Core content organized by topic.

### Subsection

Detailed information with examples.

## Examples

Practical, tested examples.

## Troubleshooting

Common issues and solutions.

## Additional Resources

- [Related Doc 1](link.md)
- [Related Doc 2](link.md)
```

### Command Documentation Template

```markdown
### Command Name

Brief description of what the command does.

**Usage:**
\`\`\`bash
command --flags arguments
\`\`\`

**Options:**
- `--flag` - Description of flag
- `--another-flag` - Description of another flag

**Examples:**
\`\`\`bash
# Example use case
command --flag value

# Another example
command --another-flag "value with spaces"
\`\`\`

**See also:** [Related Command](link.md)
```

### Service Documentation Template

```markdown
# Service Name

Brief description of the service and its purpose.

## Overview

- **Purpose**: What the service provides
- **Port**: Port number (from constants.nix)
- **URL**: Default access URL
- **Dependencies**: Required services or components

## Configuration

### Basic Setup

\`\`\`nix
services.servicename = {
  enable = true;
  # Basic options
};
\`\`\`

### Advanced Options

\`\`\`nix
services.servicename = {
  enable = true;
  # Advanced configuration
};
\`\`\`

## Integration

How this service integrates with:
- Nginx (reverse proxy)
- Monitoring (Prometheus/Grafana)
- Other services

## Monitoring

- **Metrics**: Available Prometheus metrics
- **Logs**: Log location and format
- **Dashboard**: Grafana dashboard (if applicable)

## Troubleshooting

### Issue 1
**Symptoms**: Description
**Cause**: Explanation
**Solution**: Steps to resolve

## Additional Resources

- [Service Documentation](external-link)
- [Related Service](internal-link.md)
```

---

## Quality Checklist

### Documentation Quality Standards

Every documentation file should meet these criteria:

#### Structure
- [ ] Clear, descriptive title
- [ ] Overview section explaining purpose
- [ ] Logical organization with appropriate headings
- [ ] Consistent heading hierarchy (no skipped levels)

#### Content
- [ ] Accurate, up-to-date information
- [ ] Complete, working code examples
- [ ] Practical, real-world scenarios
- [ ] Troubleshooting section (if applicable)

#### Writing
- [ ] Clear, concise language
- [ ] Active voice and present tense
- [ ] Proper grammar and spelling
- [ ] Technical terms explained on first use

#### Formatting
- [ ] Consistent markdown formatting
- [ ] Proper code block language specification
- [ ] Appropriate use of bold, italic, code formatting
- [ ] Valid internal links

#### Cross-referencing
- [ ] Links to related documentation
- [ ] No broken links
- [ ] Proper relative path usage
- [ ] Section anchors where appropriate

---

## Resources

### Tools

- **Markdown Linters**: markdownlint, mdl
- **Spell Check**: aspell, codespell
- **Link Validation**: markdown-link-check
- **Markdown Preview**: GitHub preview, VSCode preview

### References

- [GitHub Flavored Markdown](https://github.github.com/gfm/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Writing Style Guide](https://developers.google.com/style)
- [Documentation Guide](https://www.writethedocs.org/guide/)

---

## Conclusion

Good documentation is an investment in project maintainability. By following these standards, we ensure that Nilfheim documentation remains:

- **Consistent** - Familiar structure across all documents
- **Accurate** - Up-to-date with current system state
- **Useful** - Practical information for real tasks
- **Maintainable** - Easy to update as system evolves

When in doubt, prioritize clarity and usefulness over completeness. It's better to have concise, accurate documentation than exhaustive but outdated information.

---

**Questions or suggestions?** Open an issue or submit a pull request to improve these standards.
