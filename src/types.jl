
using InteractiveUtils

"""
    Proposition

The set of [well-formed logical formulae](https://en.wikipedia.org/wiki/Well-formed_formula).

Supertype of [`Primitive`](@ref) and [`Compound`](@ref).
```
"""
abstract type Proposition end

"""
    Primitive <: Proposition

A proposition that is not composed of any others.

Subtype of [`Proposition`](@ref).
Supertype of [`Truth`](@ref) and [`Atom`](@ref).
"""
abstract type Primitive <: Proposition end

"""
    Compound <: Proposition

A proposition composed from one or more [`Primitive`](@ref) propositions.

Subtype of [`Proposition`](@ref).
Supertype of [`Literal`](@ref), [`Clause`](@ref), and [`Expressive`](@ref).
"""
abstract type Compound <: Proposition end

"""
    Expressive <: Compound

A proposition that is [expressively complete](https://en.wikipedia.org/wiki/Completeness_(logic)).

Subtype of [`Compound`](@ref).
Supertype of [`Valuation`](@ref), [`Tree`](@ref), [`Normal`](@ref), and [`Pretty`](@ref).
"""
abstract type Expressive <: Compound end

"""
    Truth{V <: Union{Val{:⊥}, Val{:⊤}}} <: Primitive

A proposition representing a [`truth value`](https://en.wikipedia.org/wiki/Truth_value).

Subtype of [`Primitive`](@ref).
See also [`⊥`](@ref) and [`⊤`](@ref).
"""
struct Truth{V <: Union{Val{:⊥}, Val{:⊤}}} <: Primitive end

"""
    ⊤

A constant which is [true in every possible interpretation](https://en.wikipedia.org/wiki/Tautology_(logic)).

One of two valid instances of [`Truth`](@ref), the other instance being [`⊥`](@ref).

```⊤``` can be typed by ```\\top<tab>```.

# Examples
```jldoctest
julia> @p ⊤(p, q)
Truth:
 ⊤

julia> @truth_table ⊤
┌───────┐
│ ⊤     │
│ Truth │
├───────┤
│ ⊤     │
└───────┘
```
"""
const ⊤ = Truth{Val{:⊤}}()
const tautology = ⊤

"""
    ⊥

A constant which is [false in every possible interpretation](https://en.wikipedia.org/wiki/Contradiction).

One of two valid instances of [`Truth`](@ref), the other instance being [`⊤`](@ref).

```⊥``` can be typed by ```\\bot<tab>```.

# Examples
```jldoctest
julia> @p ⊥(p, q)
Truth:
 ⊥

julia> @truth_table ⊥
┌───────┐
│ ⊥     │
│ Truth │
├───────┤
│ ⊥     │
└───────┘
```
"""
const ⊥ = Truth{Val{:⊥}}()
const contradiction = ⊥

"""
    AndOr
"""
const AndOr = Union{typeof(and), typeof(or)}

"""
    NullaryOperator
"""
const NullaryOperator = Union{typeof(tautology), typeof(contradiction)}

"""
    UnaryOperator
"""
const UnaryOperator = Union{typeof(identity), typeof(not)}

"""
    BinaryOperator
"""
const BinaryOperator = Union{
    typeof(left),
    typeof(not_left),
    typeof(right),
    typeof(not_right),
    typeof(and),
    typeof(nand),
    typeof(nor),
    typeof(or),
    typeof(xor),
    typeof(xnor),
    typeof(imply),
    typeof(not_imply),
    typeof(converse_imply),
    typeof(not_converse_imply),
    typeof(tautology),
    typeof(contradiction)
}
# TODO: make traits?

"""
    BooleanOperator

A union of [`NullaryOperator`](@ref), [`UnaryOperator`](@ref), and [`BinaryOperator`](@ref).
"""
const BooleanOperator = Union{UnaryOperator, BinaryOperator}
# const BooleanOperator = Union{NullaryOperator, UnaryOperator, BinaryOperator}

"""
    Atom{SS <: Union{String, Symbol}} <: Primitive
    Atom([::Union{Symbol, String])
    Atom(::Proposition)

A proposition with [no deeper propositional structure](https://en.wikipedia.org/wiki/Atomic_formula).

A string argument can be thought of as a specific statement,
while a symbol can be variable. However, the only builtin difference
between these are how they pretty-print. An atom with a string argument will
be encompassed by quotation marks, while an atom with a symbol argument will
only show the symbol's characters.

!!! tip
    Using single character symbols (with corresponding variable names, if applicable)
    reproduces the syntax commonly found in logical literature.

!!! info
    ```Atom()``` defaults to ```Atom(:_)```. This underscore symbol is useful as a
    default, such as when converting [`Truth`](@ref)s to other forms. For example,
    ```Tree(⊥)``` is pretty-printed as ```_ ∧ ¬_```. This is a special case; it is not
    idiomatic to use for most purposes.

Subtype of [`Primitive`](@ref).

# Examples
```jldoctest
julia> Atom(:p)
Atom:
 p

julia> Atom("Logic is fun")
Atom:
 "Logic is fun"
```
"""
struct Atom{SS <: Union{String, Symbol}} <: Primitive
    p::SS

    Atom(p::SS = :_) where SS <: Union{Symbol, String} = new{SS}(p)
end

"""
    Literal{UO <: UnaryOperator} <: Compound
    Literal(::UO, ::Atom)
    Literal(::Proposition)

A proposition represented by
[an atomic formula or its negation](https://en.wikipedia.org/wiki/Literal_(mathematical_logic)).

Subtype of [`Compound`](@ref).
See also [`UnaryOperator`](@ref) and [`Atom`](@ref).

# Examples
```jldoctest
julia> r = @p ¬p
Literal:
 ¬p

julia> ¬r
Atom:
 p
```
"""
struct Literal{UO <: UnaryOperator} <: Compound
    p::Atom

    Literal(::UO, p::Atom) where UO <: UnaryOperator = new{UO}(p)
end

"""
    Clause{
        AO <: AndOr,
        L <: Literal
    } <: Compound
    Clause(::AO, [::Vector{Proposition}])
    Clause(::AO, ::Proposition...)

A proposition represented as either a
[conjunction or disjunction of literals](https://en.wikipedia.org/wiki/Clause_(logic).

!!! info
    An empty clause is logically equivalent to the [`identity`](@ref) element of it's binary operator.

See also [`Literal`](@ref).
Subtype of [`Compound`](@ref).

# Examples
```
julia> Clause(and)
Clause:
 ⊥

julia> @p Clause(and, p, q)
Clause:
 p ∧ q

julia> @p Clause(or, [¬p, q])
Clause:
 ¬p ∨ q
```
"""
struct Clause{AO <: AndOr, L <: Literal} <: Compound
    p::Vector{L}

    Clause(::AO, ps::Vector{L} = Literal[]) where {AO <: AndOr, L <: Literal} = new{AO, L}(union(ps))
end

"""
    Normal{AO <: AndOr, C <: Clause} <: Expressive
    Normal(::typef(and), ::Vector{Clause{typeof(or)}})
    Normal(::typef(or), ::Vector{Clause{typeof(and)}})
    Normal(::Proposition)

A proposition represented in [conjunctive](https://en.wikipedia.org/wiki/Conjunctive_normal_form)
or [disjunctive](https://en.wikipedia.org/wiki/Disjunctive_normal_form) normal form.

!!! info
    An empty normal form is logically equivalent to the [`identity`](@ref) element of it's binary operator.

Subtype of [`Expressive`](@ref).

# Examples
```jldoctest
julia> s = @p Normal(and, Clause(or, p, q), Clause(or, ¬r))
Normal:
 (p ∨ q) ∧ (¬r)

julia> ¬s
Normal:
 (¬p ∧ ¬q) ∨ (r)
```
"""
struct Normal{AO <: AndOr, C <: Clause} <: Expressive
    p::Vector{C}

    Normal(::A, ps::Vector{<:Clause{typeof(or)}} = Clause{typeof(or)}[]) where A <: typeof(and) = new{A, eltype(ps)}(union(ps))
    Normal(::O, ps::Vector{<:Clause{typeof(and)}} = Clause{typeof(and)}[]) where O <: typeof(or) = new{O, eltype(ps)}(union(ps))
end

"""
    Interpretation

# Examples
"""
struct Interpretation{C <: Clause{typeof(and)}, T <: Truth} <: Proposition
    p::C
    q::T
end
# not(p::Interpretation) = Interpretation(p.p, not(p.q))
# is_tautology(p::Interpretation{typeof(⊤)}) = true
# is_tautology(p::Interpretation{typeof(⊥)}) = false
# solve(p::Valuation) = map(x -> x.p, filter(is_tautology, p.p))
# struct Valuation{I <: Interpretation} <: Expressive
#     p::Vector{I}
# end

"""
    Valuation{P <: Pair{<:Vector{<:Pair{<:Atom, <:Truth}}, <:Truth}} <: Expressive
    Valuation(::Vector{P})
    Valuation(::Proposition)

Proposition represented by a vector of
[interpretations](https://en.wikipedia.org/wiki/Interpretation_(logic)).

Subtype of [`Expressive`](@ref).

# Examples
```jldoctest
julia> @p Valuation(p ∧ q)
Valuation:
 [p => ⊤, q => ⊤] => ⊤
 [p => ⊥, q => ⊤] => ⊥
 [p => ⊤, q => ⊥] => ⊥
 [p => ⊥, q => ⊥] => ⊥

julia> Valuation(⊥)
Valuation:
 [] => ⊥
```
"""
struct Valuation{P <: Pair} <: Expressive # {<:Vector{<:Pair{<:Atom, <:Truth}}, <:Truth}} <: Expressive
    p::Vector{P}

    function Valuation(p::Vector{P}) where P <: Pair # {Vector{Pair{<:Atom, <:Truth}}, <:Truth}}
        isempty(p) && error("TODO: write this exception")
        return new{P}(union(p))
    end
end

"""
    Tree{
        O <: BooleanOperator,
        P <: Union{Proposition, Tuple{Proposition, Proposition}}
    } <: Expressive
    Tree(::UnaryOperator, ::Atom)
    Tree(::BinaryOperator, ::Tree, ::Tree)
    Tree(::Proposition)

Proposition represented by an [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree).

Subtype of [`Expressive`](@ref).

# Examples
```jldoctest
julia> r = @p p ⊻ q
Tree:
 p ⊻ q

julia> @p ¬r → s
Tree:
 (p ↔ q) → s
```
"""
struct Tree{
    BO <: BooleanOperator,
    TP <: Union{Tuple{Proposition}, Tuple{Proposition, Proposition}}
} <: Expressive
    p::TP

    Tree(::UO, p::A) where {UO <: UnaryOperator, A <: Atom} = new{UO, Tuple{A}}((p,))
    Tree(::BO, p::T1, q::T2) where {BO <: BinaryOperator, T1 <: Tree, T2 <: Tree} = new{BO, Tuple{T1, T2}}((p, q))
end

get_concrete_types(type::UnionAll) = type
get_concrete_types(type::DataType) = mapreduce(get_concrete_types, vcat, subtypes(type))

get_abstract_types(type::UnionAll) = []
get_abstract_types(type::DataType) = mapreduce(get_abstract_types, vcat, subtypes(type), init = type)

const concrete_propositions = get_concrete_types(Proposition)
const abstract_propositions = get_abstract_types(Proposition)
const atomic_propositions = [Atom, Literal{typeof(identity)}, Tree{typeof(identity)}]
const literal_propositions = [
    atomic_propositions...,
    Literal{typeof(not)},
    Tree{typeof(not), <:Tuple{Tree{typeof(identity), <:Tuple{Atom}}}}
]
const NonTruth = Union{setdiff(concrete_propositions, [Truth])...}
const NonExpressive = Union{setdiff(abstract_propositions, [Proposition, Expressive])...}
# TODO: make traits?
