# Syntax Specification

**Version:** 0.1  
**Status:** Draft

## 1. Variables

Every variable must have an explicit type.

```text
let count: i32 = 10
var score: i32 = 100
score = score + 10
```

- `let` declares an immutable variable.
- `var` declares a mutable variable.
- Type inference is not allowed.

## 2. Primitive Types

The language provides a minimal set of primitive types based on fundamental machine representations.

- `i8`, `i16`, `i32`, `i64`: signed integers.
- `u8`, `u16`, `u32`, `u64`: unsigned integers.
- `f32`, `f64`: floating-point numbers.
- `bool`: Boolean values.

Primitive types have defined widths and semantics. Their machine-level implementation depends on the target architecture.

## 3. Type Construction

New types are defined through explicit type-construction rules rather than adding arbitrary primitive types.

### Structures

```text
struct Point {
    x: f64
    y: f64
}
```

### Arrays

```text
type Vector3 = [3]f32
```

### References

```text
type IntRef = &i32
```

The exact syntax and semantics of arrays, references, and other type constructors must be specified before implementation.

## 4. Functions

All parameters and return types must be explicit.

```text
fn add(a: i32, b: i32) -> i32 {
    return a + b
}
```

## 5. Control Flow

Conditions must have type `bool`.

```text
if score > 0 {
    score = score - 1
}
```

The initial version supports `if`, `else`, and `while`.

## 6. Formatting

- The formatter is separate from the compiler.
- Formatting may run on save or through an explicit command.
- The compiler must not modify source files.
- Formatting must preserve program semantics.

## 7. Design Rules

- Primitive types form a small, fixed foundation.
- Composite types are constructed using explicit rules.
- All declarations must specify their types.
- Implicit type conversions are prohibited.
- Type definitions must have deterministic layout and semantics.
- Platform-specific representations must be documented.

## 8. Open Questions

- Which type constructors are included in the initial version?
- How are arrays, pointers, references, and function types represented?
- How are memory layout and alignment defined?
- Which type conversions are allowed explicitly?
- How are platform-dependent types exposed?

