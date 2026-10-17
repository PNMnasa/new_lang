# Language Specification

**Version:** 0.1  
**Status:** Draft
**Author**: AI wrote the entire description

## 1. Overview

A general-purpose, statically typed, compiled programming language designed to be:

- Fast, with performance close to native machine code.
- Memory-safe, with safety enforced primarily at compile time.
- Simple to learn, use, and implement.
- Concise without sacrificing readability.
- Portable across operating systems and CPU architectures.

## 2. Basic Design

- **Compilation:** Compile source code into native machine code.
- **Typing:** Use static typing with type inference where appropriate.
- **Memory:** Aim for memory safety without requiring garbage collection.
- **Syntax:** Prefer concise, readable, and consistent syntax.
- **Errors:** Detect errors at compile time whenever possible.
- **Portability:** Support multiple platforms through a portable compiler backend.

## 3. Basic Language Features

The initial language is expected to support:

- Primitive types and variables.
- Functions and return values.
- Arithmetic and logical expressions.
- Conditional statements and loops.
- User-defined types.
- Modules and imports.
- Error handling.
- Strings and collections.
- Memory and resource management.

## 4. Design Principles

1. Prefer simple rules over numerous special cases.
2. Make behavior predictable.
3. Avoid unnecessary runtime overhead.
4. Enforce safety without requiring excessive boilerplate.
5. Keep common code concise and readable.
6. Add features only when their benefits justify their complexity.

## 5. Initial Implementation

- Implementation language: Zig.
- Compiler backend: LLVM.
- Initial target: Windows x86-64.
- Output: Native executable.

The compiler should be designed to support additional operating systems and architectures later.

## 6. Non-Goals

The language does not aim to:

- Be faster than Assembly in every situation.
- Copy the complete feature set of an existing language.
- Minimize source-code length at the expense of readability.
- Support every platform in the first release.

## 7. Future Decisions

The following details will be specified separately as the language develops:

- Exact syntax and grammar.
- Type system and type inference.
- Memory-management model.
- Error-handling model.
- Standard library.
- Module and package system.
- Foreign-function interface.
- Optimization and runtime behavior.

## 8. Initial Milestone

Build a minimal compiler capable of compiling a simple program into a native executable, then expand the language incrementally while validating correctness, safety, and performance.