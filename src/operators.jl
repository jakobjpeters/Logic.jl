
import Base: !, &, nand, nor, xor, |, ⊻, ⊼, ⊽

# Nullary Operators

"""
    tautology()
    ⊤()

Logical [true](https://en.wikipedia.org/wiki/Tautology_(logic)) operator.

`⊤` can be typed by `\\top<tab>`.

# Examples
```jldoctest
julia> TruthTable([PAndQ.Tree(⊤)])
┌───┐
│ ⊤ │
├───┤
│ ⊤ │
└───┘
```
"""
function tautology end
const ⊤ = tautology

"""
    contradiction()
    ⊥()

Logical [false](https://en.wikipedia.org/wiki/Contradiction) operator.

`⊥` can be typed by `\\bot<tab>`.

# Examples
```jldoctest
julia> TruthTable([PAndQ.Tree(⊥)])
┌───┐
│ ⊥ │
├───┤
│ ⊥ │
└───┘
```
"""
function contradiction end
const ⊥ = contradiction

# Unary Operators

"""
    identity(p)
    𝒾(p)

Logical [identity](https://en.wikipedia.org/wiki/Law_of_identity) operator.

# Examples
```jldoctest
julia> @atomize TruthTable([𝒾(p)])
┌───┐
│ p │
├───┤
│ ⊤ │
│ ⊥ │
└───┘
```
"""
identity
const 𝒾 = identity

"""
    not(p)
    ¬p

Logical [negation](https://en.wikipedia.org/wiki/Negation) operator.

`¬` can be typed by `\\neg<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([¬p])
┌───┬────┐
│ p │ ¬p │
├───┼────┤
│ ⊤ │ ⊥  │
│ ⊥ │ ⊤  │
└───┴────┘
```
"""
!
const ¬ = const not = !

# Binary Operators

"""
    and(p, q)
    p ∧ q

Logical [conjunction](https://en.wikipedia.org/wiki/Logical_conjunction) operator.

`∧` can be typed by `\\wedge<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ∧ q])
┌───┬───┬───────┐
│ p │ q │ p ∧ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
&
const ∧ = const and = &

"""
    nand(p, q)
    p ⊼ q

Logical [non-conjunction](https://en.wikipedia.org/wiki/Sheffer_stroke) operator.

`⊼` can be typed by `\\nand<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ⊼ q])
┌───┬───┬───────┐
│ p │ q │ p ⊼ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
nand

"""
    nor(p, q)
    p ⊽ q

Logical [non-disjunction](https://en.wikipedia.org/wiki/Logical_NOR) operator.

`⊽` can be typed by `\\nor<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ⊽ q])
┌───┬───┬───────┐
│ p │ q │ p ⊽ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
nor

"""
    or(p, q)
    p ∨ q

Logical [disjunction](https://en.wikipedia.org/wiki/Logical_disjunction) operator.

`∨` can be typed by `\\vee<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ∨ q])
┌───┬───┬───────┐
│ p │ q │ p ∨ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
|
const ∨ = const or = |

"""
    xor(p, q)
    p ⊻ q

Logical [exclusive disjunction](https://en.wikipedia.org/wiki/Exclusive_or) operator.

`⊻` can be typed by `\\xor<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ⊻ q])
┌───┬───┬───────┐
│ p │ q │ p ⊻ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
xor

"""
    xnor(p, q)
    p ↔ q

Logical [exclusive non-disjunction]
(https://en.wikipedia.org/wiki/Logical_biconditional) operator.

`↔` can be typed by `\\leftrightarrow<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ↔ q])
┌───┬───┬───────┐
│ p │ q │ p ↔ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
function xnor end
const ↔ = xnor

"""
    not_imply(p, q)
    p ↛ q

Logical [non-implication](https://en.wikipedia.org/wiki/Material_nonimplication) operator.

`↛` can be typed by `\\nrightarrow<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ↛ q])
┌───┬───┬───────┐
│ p │ q │ p ↛ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
function not_imply end
const ↛ = not_imply

"""
    imply(p, q)
    p → q

Logical [implication](https://en.wikipedia.org/wiki/Material_conditional) operator.

`→` can be typed by `\\rightarrow<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p → q])
┌───┬───┬───────┐
│ p │ q │ p → q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
function imply end
const → = imply

"""
    not_converse_imply(p, q)
    p ↚ q

Logical [converse non-implication](https://en.wikipedia.org/wiki/Converse_nonimplication) operator.

`↚` can be typed by `\\nleftarrow<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ↚ q])
┌───┬───┬───────┐
│ p │ q │ p ↚ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
function not_converse_imply end
const ↚ = not_converse_imply

"""
    converse_imply(p, q)
    p ← q

Logical [converse implication](https://en.wikipedia.org/wiki/Converse_(logic)#Implicational_converse) operator.

`←` can be typed by `\\leftarrow<tab>`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ← q])
┌───┬───┬───────┐
│ p │ q │ p ← q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
function converse_imply end
const ← = converse_imply

# Internals

## Union Types

"""
    NullaryOperator

The `Union` of logical [operators](@ref nullary_operators) that take zero arguments.
"""
const NullaryOperator = union_typeof((⊤, ⊥))

"""
    UnaryOperator

The `Union` of logical [unary operators](@ref unary_operators).
"""
const UnaryOperator = union_typeof((𝒾, ¬))

"""
    BinaryOperator

The `Union` of logical [binary operators](@ref binary_operators).
"""
const BinaryOperator = union_typeof((∧, ⊼, ⊽, ∨, ⊻, ↔, →, ↛, ←, ↚))

"""
    LogicalOperator

The `Union` of logical [operators](@ref operators_operators).
"""
const LogicalOperator = Union{NullaryOperator, UnaryOperator, BinaryOperator}

"""
    CommutativeOperator

The `Union` of logical [operators](@ref operators_operators) with the [commutative property]
(https://en.wikipedia.org/wiki/Commutative_property).
"""
const CommutativeOperator = union_typeof((∧, ⊼, ⊽, ∨, ⊻, ↔))

"""
    AssociativeOperator

The `Union` of logical [operators](@ref operators_operators) with the [associative property]
(https://en.wikipedia.org/wiki/Associative_property).
"""
const AssociativeOperator = union_typeof((∧, ∨, ⊻, ↔))

"""
    AndOr

The `Union` of [`and`](@ref &) and [`or`](@ref |).
"""
const AndOr = union_typeof((∧, ∨))

# Reductions

"""
    conjunction(ps)
    ⋀(ps)

Equivalent to `foldl(∧, ps; init = true)`.

`⋀` can be typed by `\\bigwedge<tab>`.

See also [`and`](@ref &).

# Examples
```jldoctest
julia> @atomize ⋀([p, q, r, s])
((p ∧ q) ∧ r) ∧ s
```
"""
conjunction(ps) = foldl(∧, ps; init = true)
const ⋀ = conjunction

"""
    disjunction(ps)
    ⋁(ps)

Equivalent to `foldl(∨, ps; init = false)`.

`⋁` can be typed by `\\bigvee<tab>`.

See also [`or`](@ref |).

# Examples
```jldoctest
julia> @atomize ⋁([p, q, r, s])
((¬¬p ∨ q) ∨ r) ∨ s
```
"""
disjunction(ps) = foldl(∨, ps; init = false)
const ⋁ = disjunction

# Utilities

"""
    arity(lo)

Return the [arity](https://en.wikipedia.org/wiki/Arity)
of the given logical [operator](@ref operators_operators).

# Examples
```jldoctest
julia> arity(tautology)
0

julia> arity(not)
1

julia> arity(and)
2
```
"""
arity(::NullaryOperator) = 0
arity(::UnaryOperator) = 1
arity(::BinaryOperator) = 2
