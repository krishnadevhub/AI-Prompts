# PHP and Symfony Code Review Playbook

## Overview

- This playbook provides a structured approach to conducting consistent, high-quality code reviews for PHP and Symfony projects
- Designed to help reviewers catch defects early, maintain security standards, and ensure changes align with ticket requirements
- Written for Symfony applications using Doctrine ORM and Twig templating, but most guidance applies broadly to PHP development
- Every review should start from the ticket: verify the PR implements all requirements and acceptance criteria

### Review Workflow

1. **Preparation** - Read ticket description and acceptance criteria; note edge cases and risky areas
2. **Initial Scan** - Skim file list and diff to identify main themes (new controllers, entity changes, migrations)
3. **Local Verification** - Run tests, linters, and static analysis; note any failures
4. **Systematic Review** - Walk through each section of this playbook
5. **Feedback** - Summarise findings; distinguish blockers from suggestions

---

## Bug Detection

### Logical Errors
- Verify each new/changed method handles null values, empty collections, and unexpected inputs safely
- Check for potential null entity relations in Doctrine (e.g., `$entity->getRelation()->getField()` without null check)
- Look for off-by-one errors in date calculations, array indexing, and loop boundaries

### Error Handling
- Ensure exceptions are caught and handled appropriately rather than causing generic 500 errors
- Verify error messages provide useful feedback without exposing sensitive information
- Check that exceptions are logged with sufficient context for debugging

### Edge Cases
- Test boundary values mentally: zero results, single result, maximum expected size
- Verify pagination or limits are used where large result sets are possible
- Check that state transitions are complete (no missing or unreachable states)

### Race Conditions
- Look for concurrent update risks in cron commands or shared counter/flag updates
- Verify transactional handling or database locking where appropriate
- Check for potential deadlocks in complex transaction scenarios

---

## Security

### SQL Injection
- Ensure all database queries use Doctrine ORM or parameterised queries
- Flag any raw SQL with string concatenation as an immediate red flag
- Check repositories and datagrid SQL for safe parameter binding

### XSS (Cross-Site Scripting)
- Verify user-supplied data in Twig uses `{{ }}` (auto-escaped) not `|raw`
- If `|raw` is used, ensure there is solid justification (trusted backend-generated HTML only)
- Check JavaScript for unsafe DOM manipulation with user input

### CSRF Protection
- Verify all forms (including AJAX) have CSRF tokens enabled
- Check that Symfony form CSRF protection is not disabled
- Ensure state-changing operations require valid CSRF tokens

### Authentication & Authorisation
- Check new routes have appropriate security configuration (firewalls, access control, voters)
- Verify `isGranted` checks are in place for sensitive operations
- Ask: "Who should access this?" and "Where is that enforced?"

### Sensitive Data Exposure
- Ensure passwords, tokens, and PII are not logged in plain text
- Verify API responses do not expose internal IDs, tokens, or sensitive data
- Check that sensitive fields use appropriate hashing or encryption

### Mass Assignment
- Verify form types only allow intended fields to be writable
- Check that DTOs have explicit field lists, not blanket entity binding
- Ensure request data is validated before entity population

### File Upload Security
- Check MIME type and extension validation
- Verify file size limits are enforced
- Ensure uploaded files are stored outside web root or served through validated controllers

### Input Validation
- Ensure all user input uses Symfony Validator or centralised validation
- Never rely solely on client-side validation
- Check for proper sanitisation of special characters

---

## Performance

### N+1 Query Problems
- Look for loops that access lazy-loaded Doctrine relations
- Check if collections trigger separate queries per iteration
- Suggest eager loading with join queries or batch fetching where needed

### Database Query Optimisation
- Look for non-selective filters or missing database indexes
- Question large unpaginated queries in controllers
- Check for unnecessary queries that could be combined or cached

### Caching
- Verify heavy computations are not repeated unnecessarily
- Check if expensive queries or API calls could benefit from caching
- Look for opportunities to use Symfony's HTTP cache, app cache, or Doctrine result cache

### Large Dataset Handling
- Ensure list endpoints use pagination and limits
- Flag any endpoints returning unbounded data
- Check memory usage for operations processing large collections

### Asset Optimisation
- Verify new JavaScript/CSS goes through the build pipeline (Webpack Encore)
- Check for large bundle sizes or duplication
- Ensure assets are minified for production

---

## Best Practices (Symfony/PHP)

### Coding Standards
- Code should follow PSR-12 and project style tools (PHP-CS-Fixer, ECS)
- Flag obvious style drift but trust automated tools for formatting
- Ensure consistent naming conventions throughout

### Dependency Injection
- New services should be wired via the Symfony service container
- Avoid instantiating dependencies with `new` inside controllers/services
- Prefer constructor injection for required dependencies

### Symfony Components
- Use Symfony's built-in components (Forms, Validator, EventDispatcher, Console)
- Avoid reinventing infrastructure the framework provides
- Follow Symfony conventions for configuration and service definitions

### Repository Pattern
- Doctrine queries should live in repositories, not controllers or Twig
- Controllers should be thin, delegating business logic to services
- Keep data access logic separate from presentation logic

### Doctrine Entities & Migrations
- Every entity field change must have a corresponding migration
- Migrations must be reversible (`down()` should undo `up()`)
- Run `doctrine:schema:validate` to catch mapping mismatches

### Type Hints & Return Types
- Use strict types and explicit return types
- Avoid `mixed` or untyped arguments unless necessary
- Type declarations improve IDE support and catch errors early

### SOLID Principles
- Watch for classes with too many responsibilities (Single Responsibility)
- Avoid tight coupling between unrelated components
- Ensure interfaces are focused and not forcing unnecessary implementations

---

## Readability & Maintainability

### Naming
- Methods and variables should express intent clearly
- Business rules should be understandable from names alone
- Avoid abbreviations that are not universally understood
- Use domain-specific terminology consistently

### Function Responsibility
- Prefer small, focused methods that do one thing well
- Extract private helpers when methods grow large
- A method should fit on one screen without scrolling

### DRY (Don't Repeat Yourself)
- Look for repeated code blocks in validation, security checks, query building
- Propose centralising common patterns into shared methods or services
- Avoid premature abstraction; some duplication is acceptable if contexts differ

### Comments & Documentation
- Comments should explain "why" not "what"
- PHPDoc blocks are valuable for public APIs and complex methods
- The best code is self-documenting through clear naming

### Constants
- Replace magic numbers and strings with named constants
- Status codes, configuration values, and business rules should use constants
- Group related constants in dedicated classes or interfaces

---

## Test Coverage

### Unit Tests
- Non-trivial business logic and services should have unit tests
- Ask: "How would I know this still works after a refactor?"
- Tests should verify behaviour, not implementation details

### Functional Tests
- New routes/controllers should have functional tests
- Cover happy path and relevant error scenarios
- Use Symfony's WebTestCase for HTTP response testing

### Edge Cases
- Tests should cover boundary conditions from ticket/acceptance criteria
- Verify behaviour for empty inputs, maximum values, and error conditions
- Include tests for null handling and invalid data

### Test Quality
- Tests should use fixtures and mocking sensibly
- Avoid tight coupling to implementation details
- Tests should not break when internal method names change

### Coverage Standards
- New code should not significantly decrease overall coverage
- Critical paths should have comprehensive test coverage
- If project has coverage requirements, verify they are met

---

## Additional Checks

### Database Migrations
- Migrations must be reversible and idempotent
- `down()` method should correctly undo `up()` method
- Check migrations do not assume data that might not exist in all environments

### Dependencies
- New Composer packages should be justified
- Check for security vulnerabilities in new dependencies
- Avoid duplicating functionality already available in the project

### API Responses
- New endpoints should follow project's standard response format
- Error responses should be consistent and informative
- Check for proper HTTP status codes

### Logging
- Sensitive operations should log enough for diagnosis without leaking secrets
- Avoid noisy debug logging in hot paths
- Use appropriate log levels (error, warning, info, debug)

### Debugging Artefacts
- Remove `dd()`, `var_dump()`, `die()` statements
- Remove leftover test routes or endpoints
- Remove `console.log` statements from Twig/JavaScript

### Environment Configuration
- Sensitive values should use environment variables, not hardcoded
- Check for environment-specific configurations handled properly
- Verify `.env` files are not committed with secrets

---

## Quick Reference Checklist

| Category | Key Checks |
|----------|------------|
| **Requirements** | All acceptance criteria implemented; no unexpected scope changes |
| **Bug Detection** | Null handling; error handling; boundary conditions |
| **Security** | Parameterised queries; escaped output; CSRF tokens; authorisation |
| **Performance** | No N+1 queries; pagination; appropriate caching |
| **Best Practices** | DI used; thin controllers; migrations present; types declared |
| **Readability** | Clear naming; focused methods; DRY code |
| **Testing** | Tests for new logic; edge cases covered |
| **Additional** | Reversible migrations; no debug code; appropriate logging |

---