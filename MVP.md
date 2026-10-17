# Minimum Viable Compiler

**Version:** 0.1  
**Status:** Draft

## 1. Goal

Build a minimal compiler that translates source code into a native executable.

## 2. Implementation

- Implementation language: Zig.
- Backend: LLVM.
- Initial target: Windows x86-64.
- Output: Native executable.
- Source extension: `.mas`.

## 3. Language Features

The initial version supports:

- Explicitly typed variables.
- Immutable and mutable bindings.
- Primitive integer, floating-point, and Boolean types.
- Arithmetic and comparison operators.
- Functions with explicit parameter and return types.
- Conditional statements and `while` loops.
- Structures and fixed-size arrays.
- Explicit type conversions.
- Compile-time syntax and type errors.

## 4. Type System

- No implicit type inference for declarations.
- No implicit type conversions.
- Composite types are constructed from supported types using predefined rules.
- Type definitions must have deterministic semantics.
- Unsupported types and operations must produce compiler errors.

## 5. Compiler Pipeline

1. Read source files.
2. Tokenize source code.
3. Parse tokens into an AST.
4. Resolve names and declarations.
5. Check types and language rules.
6. Generate LLVM IR.
7. Verify and optimize LLVM IR.
8. Generate object files.
9. Link the executable.

## 6. Development Tools

The initial toolchain includes:

- Compiler executable.
- Formatter executable or command.
- Automated tests.
- A minimal build script.

Formatting must never happen implicitly during compilation.

## 7. Out of Scope

The initial version does not require:

- Generics.
- Macros.
- A package manager.
- A comprehensive standard library.
- Garbage collection.
- Advanced concurrency features.
- Multiple target architectures.
- A stable foreign-function interface.

## 8. Completion Criteria

The MVP is complete when it can:

- Compile a program containing `main`.
- Perform arithmetic and call functions.
- Execute conditional statements and loops.
- Reject invalid syntax and type mismatches.
- Generate and run a native executable.
- Format source code without changing its semantics.
- Pass automated tests on the supported target.

## 9. Next Milestone

Implement the lexer and parser in Zig, then compile a small valid program end to end through LLVM.

