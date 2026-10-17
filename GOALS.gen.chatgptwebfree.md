# Language Goals
## 1. Vision

Create a general-purpose, statically typed, compiled programming language that combines:

- **Performance:** Generate efficient native machine code with minimal runtime overhead.
- **Safety:** Prevent common memory-safety errors at compile time wherever practical.
- **Simplicity:** Keep the language specification, compiler implementation, and development workflow understandable.
- **Conciseness:** Express common programming patterns with minimal boilerplate.
- **Portability:** Support multiple operating systems and CPU architectures through a portable compiler backend.

The language takes inspiration from Assembly, Rust, Go, and Python without requiring exact compatibility with any of them.

## 2. Core Goals

### 2.1. Performance

- Compile to native machine code.
- Use LLVM as the initial code-generation and optimization backend.
- Avoid mandatory garbage collection and unnecessary runtime overhead.
- Prefer predictable performance and explicit costs over hidden work.
- Provide optimization levels suitable for both development and production.
- Measure performance with reproducible benchmarks rather than assuming that design choices are faster.

**Success criteria:**
- Compiled programs can approach the performance of established native languages for comparable workloads.
- Simple functions do not require unnecessary runtime support.
- Performance regressions can be detected through automated benchmarks.

### 2.2. Memory Safety

- Aim to prevent use-after-free, double-free, dangling references, and invalid memory access in safe code.
- Prefer compile-time enforcement over runtime checks when practical.
- Investigate ownership and borrowing as the primary memory-management model.
- Avoid requiring a garbage collector.
- Clearly distinguish safe operations from explicitly unsafe operations.
- Define the behavior of pointers, references, lifetimes, and resource cleanup precisely.

**Success criteria:**
- Safe programs cannot cause undefined behavior through the language's supported memory operations.
- Memory-management rules are documented and testable.
- Unsafe operations have explicit syntax and well-defined restrictions.

### 2.3. Language Simplicity

- Keep the number of fundamental language constructs small.
- Prefer one clear way to express common operations.
- Avoid features that introduce substantial complexity without a strong practical benefit.
- Provide readable compiler errors with actionable explanations.
- Keep the language specification independent of implementation details.

**Success criteria:**
- Beginners can understand basic programs without learning a large set of special rules.
- The compiler can be implemented and maintained by a small team.
- Advanced features do not make basic code unnecessarily difficult to read.

### 2.4. Concise Syntax

- Minimize repetitive declarations and unnecessary punctuation.
- Use type inference where it improves readability without obscuring meaning.
- Keep function definitions, control flow, and error handling compact.
- Preserve explicit types and ownership annotations where they improve safety or clarity.
- Avoid syntax whose brevity makes code ambiguous or difficult to maintain.

**Success criteria:**
- Common programs require less boilerplate than equivalent programs in many conventional systems languages.
- Conciseness does not compromise static checking, diagnostics, or readability.

### 2.5. Portability

- Target Windows, Linux, and macOS.
- Begin implementation and testing on Windows x86-64.
- Design the compiler to support additional CPU architectures, including ARM64.
- Separate target-independent language semantics from target-specific code generation and linking.
- Avoid unnecessary dependence on operating-system-specific behavior.

**Success criteria:**
- The same source program can compile for multiple supported targets when its dependencies permit.
- Platform-specific functionality is isolated behind documented interfaces.

## 3. Implementation Constraints

### 3.1. Compiler Implementation

- Implement the compiler frontend in Zig.
- Use LLVM as the initial backend.
- Prefer LLVM APIs for IR processing, optimization, and object-file generation.
- Keep the frontend independent of LLVM-specific implementation details where practical.
- Use a modular architecture with separate components for lexing, parsing, semantic analysis, type checking, IR generation, and diagnostics.

### 3.2. Initial Toolchain

The initial toolchain should minimize unnecessary dependencies.

Required components:
- The language compiler.
- LLVM libraries and target support during compilation.
- A suitable linker for generating executable programs.
- A minimal runtime library, if required by language features.

The initial implementation may use external LLVM tools during development. Direct API integration and a more self-contained distribution can be introduced incrementally.

### 3.3. Initial Target

- Operating system: Windows.
- Architecture: x86-64.
- Output: native executable.
- Backend: LLVM.
- Implementation language: Zig.

Additional operating systems and architectures should be added after the first end-to-end compiler pipeline is stable.

## 4. Initial MVP Scope

The first usable version should support:

- Integer and boolean types.
- Immutable and mutable local variables.
- Arithmetic and comparison operators.
- Functions, parameters, and return values.
- Conditional statements and loops.
- Lexical scopes.
- Static type checking.
- Basic ownership and resource-lifetime rules, according to the selected memory model.
- Meaningful syntax and type errors.
- Native executable generation.
- Automated unit, integration, and regression tests.

Features such as generics, macros, advanced metaprogramming, package management, concurrency primitives, and a large standard library are outside the initial MVP unless required to validate a core design decision.

## 5. Non-Goals

The project does not initially aim to:

- Achieve literal instruction-for-instruction equivalence with handwritten Assembly.
- Reproduce the complete feature sets of Rust, Go, or Python.
- Guarantee that every program is faster than programs written in other languages.
- Implement every operating system and CPU architecture immediately.
- Provide a comprehensive ecosystem before the language semantics stabilize.
- Optimize for minimum source-code length at the expense of clarity or safety.

## 6. Design Principles

When goals conflict, use the following priorities:

1. **Correctness and safety:** Language behavior must be precisely defined.
2. **Predictable performance:** Avoid unnecessary overhead and hidden costs.
3. **Simplicity:** Prefer the smallest design that satisfies real requirements.
4. **Conciseness and readability:** Reduce boilerplate without obscuring intent.
5. **Portability and extensibility:** Keep platform-specific concerns isolated.

These priorities are guidelines, not substitutes for evaluating concrete trade-offs.

## 7. Validation Strategy

Every major design decision should be validated through:

- Specification examples and counterexamples.
- Positive and negative compiler tests.
- Memory-safety tests where applicable.
- End-to-end compilation and execution tests.
- Benchmarks against established languages using comparable algorithms, optimization settings, and workloads.
- Cross-platform CI as target support expands.
- Documentation explaining language guarantees and known limitations.

Claims about safety, speed, and simplicity must be supported by implementation behavior and test results.

## 8. Project Milestones

1. Define the language's memory model, type system, error model, and basic syntax.
2. Write a concise language specification and example programs.
3. Implement a minimal Zig-based frontend.
4. Generate LLVM IR and compile a small program to a native executable.
5. Add type checking, diagnostics, and regression tests.
6. Formalize and implement the selected memory-safety model.
7. Add optimization, runtime functionality, and standard-library essentials.
8. Expand target support and publish reproducible benchmarks.

## 9. Open Design Questions

The following decisions must be resolved before the language specification is considered stable:

- Will memory management use ownership and borrowing, another compile-time model, or a combination?
- Will the language support exceptions, explicit error returns, or another error-handling model?
- Will integer overflow be checked, wrapping, or configurable?
- Will mutability be explicit by default?
- How will strings, arrays, slices, and dynamic collections be represented?
- Will the language use a C-compatible ABI for interoperability?
- How will modules, dependencies, and package distribution work?
- Which operations, if any, will require an explicit unsafe context?

These decisions should be documented and tested before they become difficult to change.

---

**Current status:** Design phase. The goals above are provisional and should be revised as the language specification and prototype develop.