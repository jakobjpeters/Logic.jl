
import Base: convert

# Types

"""
    Proposition

Set of well-formed logical formulae.

Calling an instance of ```Proposition``` will return a vector of valid interpretations.

Supertype of [`Atom`](@ref), [`Compound`](@ref), and [`Truth`](@ref).
```
"""
abstract type Proposition end

"""
Compound <: Proposition

Compound proposition.

Subtype of [`Proposition`](@ref).
Supertype of [`Literal`](@ref), [`Tree`](@ref), and [`Normal`](@ref).
"""
abstract type Compound <: Proposition end

"""
    Operator

Set of functions that operate on a logical [`Proposition`](@ref).

Supertype of [`Boolean`](@ref).
"""
abstract type Operator end

"""
    Boolean <: Operator

Set of logical connectives.

Subtype of [`Operator`](@ref).
Supertype of [`Not`](@ref), [`And`](@ref), and [`Or`](@ref).
See also [Boolean Operators](@ref).
"""
abstract type Boolean <: Operator end

"""
    Not <: Boolean <: Operator

Singleton type representing logical negation.

Subtype of [`Boolean`](@ref) and [`Operator`](@ref).
See also [`not`](@ref).
```
"""
struct Not <: Boolean end

"""
    And <: Boolean <: Operator

Singleton type representing logical conjunction.

Subtype of [`Boolean`](@ref) and [`Operator`](@ref).
See also [`and`](@ref).
"""
struct And <: Boolean end

"""
    Or <: Boolean <: Operator

Singleton type representing logical disjunction.

Subtype of [`Boolean`](@ref) and [`Operator`](@ref).
See also [`or`](@ref).
"""
struct Or <: Boolean end

"""
    Atom <: Proposition
    Atom([statement::String])

Atomic proposition.

!!! info
    Constructing an ```Atom``` with no argument, an empty string, or an underscore character
    will set ```statement = "_"```. This serves two purposes.
    Firstly, it is useful as a default proposition when converting [`Truth`](@ref)s to other forms;
    for example: ```Tree(⊥)``` is printed as ```"_" ∧ ¬"_"```.
    Secondly, this ensures that pretty-printing does not produce output such as: ``` ∧ ¬`.
    It is not idiomatic to use this as a generic proposition; use [`@atom`](@ref) instead.

Subtype of [`Proposition`](@ref).

# Examples
```jldoctest
julia> p = Atom("p")
Atom:
  "p"

julia> p()
Contingency:
  ["p" => ⊤] => ⊤
  ["p" => ⊥] => ⊥
```
"""
struct Atom <: Proposition
    statement::String

    Atom(statement::String = "") = statement == "" ? new("_") : new(statement)
end

"""
    Literal{
        L <: Union{
            Atom,
            Tuple{Not, Atom}
        }
    } <: Compound <: Proposition
    Literal(p::L)

An [`Atom`](@ref) or its negation.

Subtype of [`Compound`](@ref) and [`Proposition`](@ref).
See also [`Not`](@ref).

# Examples
```jldoctest
julia> r = ¬p
Literal:
  ¬"p"

julia> r()
Contingency:
  ["p" => ⊤] => ⊥
  ["p" => ⊥] => ⊤
```
"""
struct Literal{
    L <: Union{
        Atom,
        Tuple{Not, Atom}
    }
} <: Compound
    p::L
end

"""
    Tree{
        L <: Union{
            Tuple{Not, Compound},
            Tuple{And, Compound, Compound}
        }
    } <: Compound <: Proposition
    Tree(node::L)

Abstract syntax tree representing a compound proposition.

Note that [`Not`](@ref) and [`And`](@ref) are functionally complete operators.

Subtype of [`Compound`](@ref) and [`Proposition`](@ref).

# Examples
```jldoctest
julia> r = p ∧ ¬p
Tree:
  "p" ∧ ¬"p"

julia> r()
Truth:
  ⊥

julia> (p ∧ q)()
Contingency:
  ["p" => ⊤, "q" => ⊤] => ⊤
  ["p" => ⊤, "q" => ⊥] => ⊥
  ["p" => ⊥, "q" => ⊤] => ⊥
  ["p" => ⊥, "q" => ⊥] => ⊥
```
"""
struct Tree{
    L <: Union{
        Tuple{Not, Compound},
        Tuple{And, Compound, Compound}
    }
} <: Compound
    node::L
end

"""
    Normal{B <: Union{And, Or}} <: Compound <: Proposition
    Normal(::Union{typeof(and), typeof(or)}, p::Proposition)

The conjunctive or disjunctive normal form of a proposition.

Constructing an instance with the parameters ```([`and`](@ref), p)``` and ```([`or`](@ref), p)```
correspond to conjunctive and disjunctive normal form, respectively.

Subtype of [`Compound`](@ref) and [`Proposition`](@ref).

# Examples
```jldoctest
julia> r = Normal(and, p ∧ q)
Normal:
  (¬"p" ∨ "q") ∧ ("p" ∨ ¬"q") ∧ ("p" ∨ "q")

julia> s = Normal(or, ¬p ∨ ¬q)
Normal:
  ("p" ∧ ¬"q") ∨ (¬"p" ∧ "q") ∨ (¬"p" ∧ ¬"q")

julia> t = r ∧ s
Tree:
  (¬"p" ∨ "q") ∧ ("p" ∨ ¬"q") ∧ ("p" ∨ "q") ∧ ("p" ∧ ¬"q") ∨ (¬"p" ∧ "q") ∨ (¬"p" ∧ ¬"q")

julia> t()
Truth:
  ⊥
```
"""
struct Normal{B <: Union{And, Or} #=, L <: Literal =#} <: Compound
    clauses::Vector{Vector{Literal}}
end

"""
    Truth{V <: Union{Val{:⊥}, Val{:⊤}}} <: Proposition
    Truth(::V)

Container for the constants [`tautology`](@ref) and [`contradiction`](@ref).
Subtype of [`Proposition`](@ref).
"""
struct Truth{V <: Union{Val{:⊥}, Val{:⊤}}} <: Proposition end


"""
    ⊥
    contradiction

A constant which is false in every possible interpretation.

One of two valid instances of [`Truth`](@ref), the other instance being [`tautology`](@ref).

```⊥``` can be typed by ```\\bot<tab>```.

# Examples
```jldoctest
julia> ¬⊥
Truth:
  ⊤

julia> contradiction()
Truth:
  ⊥
```
"""
const contradiction = Truth{Val{:⊥}}()
const ⊥ = contradiction

"""
    ⊤
    tautology

A constant which is true in every possible interpretation.

One of two valid instances of [`Truth`](@ref), the other instance being [`contradiction`](@ref).

```⊤``` can be typed by ```\\top<tab>```.

# Examples
```jldoctest
julia> ¬⊤
Truth:
  ⊥

julia> tautology()
Truth:
  ⊤
```
"""
const tautology = Truth{Val{:⊤}}()
const ⊤ = tautology

"""
    Contingency <: Compound

# Examples
```jldoctest
julia> p()
Contingency:
  ["p" => ⊤] => ⊤
  ["p" => ⊥] => ⊥

julia> (p ∧ q)()
Contingency:
  ["p" => ⊤, "q" => ⊤] => ⊤
  ["p" => ⊤, "q" => ⊥] => ⊥
  ["p" => ⊥, "q" => ⊤] => ⊥
  ["p" => ⊥, "q" => ⊥] => ⊥
```
"""
struct Contingency <: Compound # TODO: parameterize
    interpretations::Vector{Pair{Vector{Pair{Atom, Truth}}}}
end


# Utility

"""
    @atom(ps...)

Instantiates [`atomic propositions`](@ref Atom).

Examples
```jldoctest
julia> @atom p q

julia> p
Atom:
  "p"

julia> q
Atom:
  "q"
```
"""
macro atom(expressions...)
    atom = expression -> :($(esc(expression)) = Atom($(string(expression))))
    atoms = map(atom, expressions)

    return :($(atoms...); nothing)
end
#=
Source:
https://github.com/ctrekker/Deductive.jl
=#

"""
    get_atoms(ps::Proposition...)

Returns a vector of [`atomic propositions`](@ref Atom) contained in ```ps```.

!!! warning
    Some atoms may optimized out of an expression, such as in ```p ∧ ⊥```.

See also [`Proposition`](@ref).

# Examples
```jldoctest
julia> r = p ∧ q
Tree:
  "p" ∧ "q"

julia> get_atoms(r)
2-element Vector{Atom}:
 "p"
 "q"
```
"""
get_atoms(::Truth) = Atom[]
get_atoms(p::Contingency) = union(
    mapreduce(
        interpretation -> map(
            literal -> first(literal), first(interpretation)),
        vcat, p.interpretations
    )
)
get_atoms(p::Atom) = [p]
get_atoms(p::Literal) = get_atoms(p.p)
get_atoms(p::Tree) = union(get_atoms(p.node))
get_atoms(node::Tuple{Operator, Vararg}) = mapreduce(p -> get_atoms(p), vcat, Base.tail(node))
get_atoms(p::Normal) = get_atoms(Tree(p))
get_atoms(ps::Proposition...) = union(mapreduce(get_atoms, vcat, ps))


# Helpers 

convert(::Type{Literal}, literal::Pair{Atom, <:Truth}) = last(literal) == ⊤ ? Literal(first(literal)) : not(first(literal))
convert(::Type{Tree}, p::typeof(⊥)) = and(Atom(), not(Atom()))
convert(::Type{Tree}, p::typeof(⊤)) = not(Tree(⊥))
convert(::Type{Tree}, p::Contingency) = mapreduce(interpretation -> mapreduce(Literal, and, first(interpretation)), or, filter(interpretation -> last(interpretation) == ⊤, p.interpretations))
convert(n::Type{<:Normal}, p::Contingency) = n(Tree(p))
convert(::Type{Tree}, p::Normal{And}) = _convert(p, or, and)
convert(::Type{Tree}, p::Normal{Or}) = _convert(p, and, or)
convert(::Type{Contingency}, p::Proposition) = p()
convert(::Type{L}, p::L) where L <: Proposition = p
convert(::Type{L}, p::Proposition) where L <: Proposition = L(p)

_convert(p, inner, outer) = mapreduce(clause -> reduce(inner, clause), outer, p.clauses)


# Consructors

# TODO: use Base.promote?
Tree(::Not, p::Atom) = Literal((Not(), p))
Tree(::Not, p::Compound) = Tree((Not(), p))

Tree(::And, p::Atom, q::Atom) = Tree(And(), Literal(p), Literal(q))
Tree(::And, p::Atom, q::Compound) = Tree(And(), Literal(p), q)
Tree(::And, p::Compound, q::Atom) = Tree(And(), p, Literal(q))
Tree(::And, p::Compound, q::Compound) = Tree((And(), p, q))

# TODO: write more conversions
Literal(p::Pair{Atom, Truth}) = convert(Literal, p)
Tree(p::Proposition) = convert(Tree, p)
Normal(::B, p::Contingency) where B <: Union{And, Or} = convert(Normal{B}, p)

Normal(::And, p::Proposition) = not(Normal(Or(), ¬p))
function Normal(::Or, p::Proposition)
    q = p()
    # TODO: change `===` to `==` - fixes `Normal(and, ⊥)`
    interpretations =
        if q === ⊤
            [[Atom() => ⊤], [Atom() => ⊥]]
        elseif q === ⊥
            [[Atom() => ⊤, Atom() => ⊥]]
        else
            map(first, filter(literal -> last(literal) == ⊤, q.interpretations))
        end

    clauses = map(interpretation -> map(Literal, interpretation), interpretations)
    return Normal{Or}(clauses)
end
