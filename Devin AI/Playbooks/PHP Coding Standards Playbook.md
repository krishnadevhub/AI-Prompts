# PHP Coding Standards and Best Practices Playbook

This playbook defines the coding standards and best practices for PHP development. All PHP code must adhere to these guidelines to ensure consistency, maintainability, and quality across the codebase.

## 1. Code Quality Standards

### 1.1 PHPDoc Requirements

All classes, methods, and complex properties must include PHPDoc comments following PSR-5 standards.

#### Method Documentation

```php
/**
 * Brief description of what the method does
 *
 * More detailed description if needed to explain complex logic,
 * edge cases, or important implementation details.
 *
 * @param string $paramName Description of the parameter and its purpose
 * @param int|null $optionalParam Optional parameter description
 * @return Type Description of what is returned
 * @throws ExceptionType When and why this exception is thrown
 * @throws AnotherException When another error condition occurs
 */
public function methodName(string $paramName, ?int $optionalParam = null): Type
{
    // Implementation
}
```

**Important:** PHPDoc comments must contain all necessary `@throws` tags for every exception type that the method can throw, including:

- Exceptions thrown directly by the method
- Exceptions thrown by called methods that are not caught
- Multiple exception types should have separate `@throws` tags with specific conditions

```php
/**
 * Process user payment and send confirmation
 *
 * @param User $user The user making the payment
 * @param float $amount The payment amount
 * @return Payment The processed payment record
 * @throws InvalidArgumentException If amount is negative or zero
 * @throws InsufficientFundsException If user has insufficient balance
 * @throws PaymentGatewayException If payment gateway communication fails
 * @throws NotificationException If confirmation email cannot be sent
 */
public function processPayment(User $user, float $amount): Payment
{
    if ($amount <= 0) {
        throw new InvalidArgumentException('Amount must be positive');
    }
    
    // Method implementation that may throw the documented exceptions
}
```

#### Class Documentation

```php
/**
 * Brief description of the class responsibility
 *
 * Detailed explanation of the class purpose, design patterns used,
 * or architectural considerations.
 *
 * @package App\Domain\Module
 */
class ClassName
{
    // Class implementation
}
```

#### Property Documentation

```php
/**
 * Description of the property purpose
 *
 * @var Type
 */
private Type $propertyName;
```

### 1.2 Code Formatting Standards

#### Line Length and Breaking

The maximum line width is 120 characters. Line breaks are required for method signatures and chained method calls that exceed this limit. When breaking method signatures across lines, align parameters vertically.

```php
// Good: Method signature with line breaks
public function longMethodName(
    string $firstParameter,
    array $secondParameter,
    ?int $thirdParameter = null
): ReturnType {
    // Implementation
}

// Good: Chained method calls
$result = $queryBuilder
    ->select('*')
    ->from('users')
    ->where('status', 'active')
    ->orderBy('created_at', 'desc')
    ->get();
```

#### Coding Standards Compliance

Follow [PSR-12](https://www.php-fig.org/psr/psr-12/) Extended Coding Style. Use 4 spaces for indentation (no tabs). Opening braces go on the same line for control structures and on a new line for classes and methods. Always declare visibility (`public`, `protected`, `private`) for properties and methods. Use `UPPER_CASE` with underscores for constants.

```php
// Good: PSR-12 compliant structure
class ExampleClass
{
    private const MAX_ITEMS = 100;
    
    private string $property;
    
    public function __construct(string $property)
    {
        $this->property = $property;
    }
    
    public function process(): void
    {
        if ($this->isValid()) {
            // Process logic
        } else {
            // Alternative logic
        }
    }
}
```

#### Import Statements

Replace Fully Qualified Names (FQN) with `use` import statements at the top of the file. Remove all unused import statements. Alphabetise import statements within their groups.

```php
<?php

declare(strict_types=1);

namespace App\Services;

use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Log;
use App\Models\User;
use App\Repositories\UserRepository;

class UserService
{
    // Instead of: new \App\Models\User()
    // Use imported class: new User()
}
```

#### Control Structures

Use a single space after control structure keywords. Do not add space after opening or before closing parentheses. Always use braces, even for single-line statements.

```php
// Good
if ($condition) {
    doSomething();
}

// Bad
if($condition) doSomething();
```

### 1.3 Type Declarations

Always use parameter and return type declarations. Use `?Type` notation for nullable parameters and returns.

```php
<?php

namespace App\Services;

class TypedExample
{
    public function calculate(int $value, ?string $option = null): float
    {
        return (float) $value;
    }
}
```

### 1.4 Naming Conventions

Classes use PascalCase (e.g., `UserController`, `PaymentService`). Methods use camelCase (e.g., `getUserById`, `processPayment`). Variables use camelCase (e.g., `$userName`, `$totalAmount`). Constants use UPPER_SNAKE_CASE (e.g., `MAX_RETRY_ATTEMPTS`, `DEFAULT_TIMEOUT`). Private and protected members use descriptive names without prefixes.

### 1.5 Best Practices

#### Single Responsibility

Each class and method should have one clear purpose. If a method is doing multiple things, consider breaking it into smaller, focused methods.

#### DRY Principle

Don't Repeat Yourself. Extract common logic into reusable methods or classes. If you find yourself copying and pasting code, it's time to refactor.

#### Early Returns

Use guard clauses to reduce nesting. This makes code easier to read and understand.

```php
// Good: Early return pattern
public function process(?User $user): void
{
    if ($user === null) {
        return;
    }
    
    if (!$user->isActive()) {
        return;
    }
    
    // Main logic here
}

// Bad: Deep nesting
public function process(?User $user): void
{
    if ($user !== null) {
        if ($user->isActive()) {
            // Main logic here
        }
    }
}
```

#### Meaningful Names

Use descriptive, self-documenting names. Variable and method names should clearly indicate their purpose without needing comments to explain them.

#### Avoid Deep Nesting

Aim for a maximum of 3-4 levels of indentation. If you find yourself going deeper, consider extracting logic into separate methods.

## 2. Code Review Checklist

When reviewing PHP code, verify the following:

1. All classes, methods, and complex properties have PHPDoc comments
2. All `@throws` tags are present for exceptions that can be thrown
3. Line length does not exceed 120 characters
4. Code follows PSR-12 formatting standards
5. All imports are used and properly organised
6. Strict types are declared
7. Type hints are present on all parameters and return types
8. Naming conventions are followed consistently
9. No deep nesting (maximum 3-4 levels)
10. Early returns are used where appropriate
11. No code duplication

## 3. Tools and Automation

Consider using the following tools to enforce these standards:

- **PHP_CodeSniffer** with PSR-12 ruleset for code style checking
- **PHPStan** or **Psalm** for static analysis and type checking
- **PHP-CS-Fixer** for automatic code formatting
- **PHPDoc** validators for documentation completeness

Configure these tools in your CI/CD pipeline to automatically check code quality on every commit.