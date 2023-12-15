
<!-- This file is generated by `.github/workflows/readme.yml`; do not edit directly. -->

<p align="center"><img width="200px" src="docs/src/assets/logo.svg"/></p>

<div align="center">

[![Documentation stable](https://img.shields.io/badge/Documentation-stable-blue.svg)](https://jakobjpeters.github.io/PAndQ.jl/stable/)
[![Documentation dev](https://img.shields.io/badge/Documentation-dev-blue.svg)](https://jakobjpeters.github.io/PAndQ.jl/dev/)
[![Codecov](https://codecov.io/gh/jakobjpeters/PAndQ.jl/branch/main/graph/badge.svg?token=XFWU66WSD7)](https://codecov.io/gh/jakobjpeters/PAndQ.jl)

[![Documentation](https://github.com/jakobjpeters/PAndQ.jl/workflows/Documentation/badge.svg)](https://github.com/jakobjpeters/PAndQ.jl/actions/workflows/documentation.yml)
[![Continuous Integration](https://github.com/jakobjpeters/PAndQ.jl/workflows/Continuous%20Integration/badge.svg)](https://github.com/jakobjpeters/PAndQ.jl/actions/workflows/continuous_integration.yml)

[![Downloads](https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/PAndQ)](https://pkgs.genieframework.com?packages=PAndQ)
[![Dependents](https://docs.juliahub.com/PAndQ/deps.svg)](https://juliahub.com/ui/Packages/PAndQ/h95uE/0.1.0?page=2)

</div>

# PAndQ.jl

## Introduction

If you like propositional logic, then you've come to the right place!

PAndQ.jl is a [computer algebra system](https://en.wikipedia.org/wiki/Computer_algebra_system) for propositional logic.

### Features

- First-class propositions
    - Syntax and pretty-printing corresponding to written logic
- Normalization
    - Negated, conjunctive, and disjunctive forms
    - Tseytin transformation
- Satisfiability solving
- Logical equivalence
- Partial interpretation
- Diagrams
    - Syntax trees
    - Truth tables
        - Plain text, HTML, Markdown, and LaTeX output
- Convert propositions to LaTeX

#### Planned

- Simplification
- Substitution
- Proofs
- Generate propositions
- Normal forms
    - Algebraic, Blake
    - Minimization
- Diagrams
    - Decision trees
    - Circuits
- Modal logic
- First order logic
- Lambda calculus
- Electronic circuits
- Satisfiability modulo theories

## Installation

```julia
julia> using Pkg: add

julia> add("PAndQ")

julia> using PAndQ
```

## Showcase

```julia
julia> ¬⊤
¬⊤

julia> @atomize p ∧ q → $1
(p ∧ q) → $(1)

julia> @variables p q
2-element Vector{PAndQ.Variable}:
 p
 q

julia> r = p ⊻ q
p ⊻ q

julia> interpret(p => ⊤, r)
⊤ ⊻ q

julia> valuation = collect(only(solutions(p ∧ q)))
2-element Vector{Pair{PAndQ.Variable, Bool}}:
 PAndQ.Variable(:p) => 1
 PAndQ.Variable(:q) => 1

julia> interpret(valuation, p ∧ q)
true

julia> s = normalize(∧, r)
(¬q ∨ ¬p) ∧ (q ∨ p)

julia> TruthTable([p ∧ ¬p, ¬p, r, s])
┌────────┬───┬───┬────┬────────────────────────────┐
│ p ∧ ¬p │ p │ q │ ¬p │ p ⊻ q, (¬q ∨ ¬p) ∧ (q ∨ p) │
├────────┼───┼───┼────┼────────────────────────────┤
│ ⊥      │ ⊤ │ ⊤ │ ⊥  │ ⊥                          │
│ ⊥      │ ⊥ │ ⊤ │ ⊤  │ ⊤                          │
├────────┼───┼───┼────┼────────────────────────────┤
│ ⊥      │ ⊤ │ ⊥ │ ⊥  │ ⊤                          │
│ ⊥      │ ⊥ │ ⊥ │ ⊤  │ ⊥                          │
└────────┴───┴───┴────┴────────────────────────────┘
```

## Related Packages

### Logic

- [Julog.jl](https://github.com/ztangent/Julog.jl)
    - Implements a Prolog-like logic programming language for propositional and first-order logic
- [LogicCircuits.jl](https://github.com/Juice-jl/LogicCircuits.jl)
    - Implements propositional logic with support for SIMD and CUDA
- [SoleLogics.jl](https://github.com/aclai-lab/SoleLogics.jl)
    - Implements propositional and modal logic
- [TruthTables.jl](https://github.com/eliascarv/TruthTables.jl)
    - Implements a macro that prints a truth table
    - PAndQ.jl implements a superset of the features in this package
- [MathematicalPredicates.jl](https://github.com/JuliaReach/MathematicalPredicates.jl)
    - Implements propositional logic
    - PAndQ.jl, Julog.jl, and SoleLogics.jl implement a superset of the features in this package
- [Satifsiability.jl](https://github.com/elsoroka/Satisfiability.jl)
    - An interface to satisfiability modulo theory solvers
    - Solvers must be installed on the user's system

#### Wrappers

- [PicoSat.jl](https://github.com/sisl/PicoSAT.jl)
    - An interface to the [PicoSAT](https://fmv.jku.at/picosat/) solver using PicoSAT_jll.jl
- [Z3.jl](https://github.com/ahumenberger/Z3.jl)
    - An interface to the [Z3 Theorem Prover](https://github.com/Z3Prover/z3) using z3_jll.jl
    - Commits [type piracy](https://docs.julialang.org/en/v1/manual/style-guide/#Avoid-type-piracy)

##### Binaries

These packages are generated by [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl).

- [PicoSAT_jll.jl](https://github.com/JuliaBinaryWrappers/PicoSAT_jll.jl)
- [z3_jll.jl](https://github.com/JuliaBinaryWrappers/z3_jll.jl)

### Computer Algebra Systems

- [Metatheory.jl](https://github.com/JuliaSymbolics/Metatheory.jl)
- [SymbolicUtils.jl](https://github.com/JuliaSymbolics/SymbolicUtils.jl)
- [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl)
- [Oscar.jl](https://github.com/oscar-system/Oscar.jl)
- [Catlab.jl](https://github.com/AlgebraicJulia/Catlab.jl)

### Constraints

- [JuMP.jl](https://github.com/jump-dev/JuMP.jl)
- [ConstraintSolver.jl](https://github.com/Wikunia/ConstraintSolver.jl)

#### Wrappers

- [Chuffed.jl](https://github.com/JuliaConstraints/Chuffed.jl)
- [CPLEXCP.jl](https://github.com/JuliaConstraints/CPLEXCP.jl)
- [BeeEncoder.jl](https://github.com/newptcai/BeeEncoder.jl)
    - 3+ years since last update
