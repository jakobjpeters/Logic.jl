
import Base: show, Stateful
import PrettyTables: pretty_table
import AbstractTrees: print_tree
using Base: Docs.HTML, show_type_name
using AbstractTrees: print_child_key

"""
    TruthTable(ps)

Construct a [truth table](https://en.wikipedia.org/wiki/Truth_table)
for the given [`Proposition`](@ref)s.

The `header` is a vector containing vectors of logically equivalent propositions.
The `body` is a matrix where the rows contain [`interpretations`](@ref) of each proposition in the given column.

See also [Nullary Operators](@ref nullary_operators).

# Examples
```jldoctest
julia> TruthTable([⊤])
┌───┐
│ ⊤ │
├───┤
│ ⊤ │
└───┘

julia> @atomize TruthTable([¬p])
┌───┬────┐
│ p │ ¬p │
├───┼────┤
│ ⊤ │ ⊥  │
│ ⊥ │ ⊤  │
└───┴────┘

julia> @atomize TruthTable([p ∧ ¬p, p ⊻ q, ¬(p ∧ q) ∧ (p ∨ q)])
┌────────┬───┬───┬───────────────────────────┐
│ p ∧ ¬p │ p │ q │ p ⊻ q, ¬(p ∧ q) ∧ (p ∨ q) │
├────────┼───┼───┼───────────────────────────┤
│ ⊥      │ ⊤ │ ⊤ │ ⊥                         │
│ ⊥      │ ⊥ │ ⊤ │ ⊤                         │
├────────┼───┼───┼───────────────────────────┤
│ ⊥      │ ⊤ │ ⊥ │ ⊤                         │
│ ⊥      │ ⊥ │ ⊥ │ ⊥                         │
└────────┴───┴───┴───────────────────────────┘
```
"""
struct TruthTable
    header::Vector{String}
    body::Matrix{Bool}

    function TruthTable(ps)
        _atoms = unique(Iterators.flatmap(atoms, ps))
        ps = union(_atoms, ps)
        _valuations = valuations(_atoms)
        _interpretations = Iterators.map(p -> vec(map(valuation -> _interpret(p, a -> Dict(valuation)[a], Bool), _valuations)), ps)

        truths_interpretations, atoms_interpretations, compounds_interpretations =
            Vector{Bool}[], Vector{Bool}[], Vector{Bool}[]

        grouped_truths = Dict(map(truth -> repeat([truth], length(_valuations)) => Proposition[], (true, false)))
        grouped_atoms = Dict(map(
            p -> map(Bool, interpretations(_valuations, p)) => Proposition[],
            _atoms
        ))
        grouped_compounds = Dict{Vector{Bool}, Vector{Proposition}}()

        for (p, interpretation) in zip(ps, _interpretations)
            _union! = (key, group) -> begin
                union!(key, [interpretation])
                union!(get!(group, interpretation, Proposition[]), [p])
            end

            if interpretation in keys(grouped_truths) _union!(truths_interpretations, grouped_truths)
            elseif interpretation in keys(grouped_atoms) _union!(atoms_interpretations, grouped_atoms)
            else _union!(compounds_interpretations, grouped_compounds)
            end
        end

        header = String[]
        body = Vector{Bool}[]
        for (_interpretations, group) in (
            truths_interpretations => grouped_truths,
            atoms_interpretations => grouped_atoms,
            compounds_interpretations => grouped_compounds
        )
            for interpretation in _interpretations
                xs = get(group, interpretation, Proposition[])
                push!(header, join(unique!(map(x -> repr("text/plain", x), xs)), ", "))
                push!(body, interpretation)
            end
        end

        new(header, reduce(hcat, body))
    end
end

# Internals

for o in (:⊤, :⊥, :𝒾, :¬, :∧, :⊼, :⊽, :∨, :⊻, :↔, :→, :↛, :←, :↚)
    @eval symbol_of(::typeof($o)) = $(QuoteNode(o))
end

"""
    symbol_of(::Operator)

Return the Unicode symbol of the given [`Operator`](@ref).

# Examples
```jldoctest
julia> PAndQ.symbol_of(⊤)
:⊤

julia> PAndQ.symbol_of(¬)
:¬

julia> PAndQ.symbol_of(∧)
:∧
```
"""
symbol_of

"""
    parenthesize(::IO, p)
"""
parenthesize(io, p) = show(io, MIME"text/plain"(), p)
function parenthesize(io, p::Union{Clause, <:Tree{<:BinaryOperator}})
    print(io, "(")
    show(io, MIME"text/plain"(), p)
    print(io, ")")
end

"""
    print_node(io, p)
"""
print_node(io, ::Compound{typeof(𝒾)}) = nothing
print_node(io, p) = printnode(io, p)

"""
    show_atom(io, ::Atom)

See also [`Atom`](@ref).
"""
show_atom(io, p::Constant) = show(io, p.value)
show_atom(io, p::Variable) = show(io, p.symbol)

# `show`

"""
    show(::IO, ::MIME"text/plain", ::Proposition)

Represent the given [`Proposition`](@ref) as a [propositional formula]
(https://en.wikipedia.org/wiki/Propositional_formula).

The value of a [`Constant`](@ref) is shown with `compact => true` in its `IOContext`.

# Examples
```jldoctest
julia> @atomize show(stdout, MIME"text/plain"(), p ⊻ q)
p ⊻ q

julia> @atomize show(stdout, MIME"text/plain"(), PAndQ.Normal(p ⊻ q))
(p ∨ q) ∧ (¬p ∨ ¬q)
```
"""
function show(io::IO, ::MIME"text/plain", p::Constant)
    print(io, "\$(")
    show_atom(IOContext(io, :compact => true), p)
    print(io, ")")
end
show(io::IO, ::MIME"text/plain", p::Variable) = print(io, p.symbol)
function show(io::IO, ::MIME"text/plain", p::Compound{<:UnaryOperator})
    print_node(io, p)
    parenthesize(io, child(p))
end
function show(io::IO, ::MIME"text/plain", p::Compound)
    _children = Stateful(children(p))
    isempty(_children) ?
        printnode(io, p) :
        for child in _children
            parenthesize(io, child)
            if !isempty(_children)
                print(io, " ")
                printnode(io, p)
                print(io, " ")
            end
        end
end

"""
    show(::IO, ::MIME"text/plain", ::TruthTable)

See also [`TruthTable`](@ref).

# Examples
```julia
julia> @atomize show(stdout, MIME"text/plain"(), TruthTable([p ∧ q]))
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
show(io::IO, ::MIME"text/plain", tt::TruthTable) =
    pretty_table(io, tt; newline_at_end = false)

"""
    show(::IO, ::Proposition)

Show the given [`Proposition`](@ref) in it's internal representation.

# Examples
```jldoctest
julia> @atomize repr(p ∧ q)
"PAndQ.Tree(and, PAndQ.Tree(identity, PAndQ.Variable(:p)), PAndQ.Tree(identity, PAndQ.Variable(:q)))"

julia> @atomize eval(Meta.parse(repr(p ∧ q)))
p ∧ q
```
"""
function show(io::IO, p::A) where A <: Atom
    show_type_name(io, A.name)
    print(io, "(")
    show_atom(io, p)
    print(io, ")")
end
function show(io::IO, p::C) where C <: Compound
    show_type_name(io, C.name)
    print(io, "(", nameof(nodevalue(p)))

    _children = Stateful(children(p))
    if !isempty(_children)
        print(io, ", ")
        p isa Union{Clause, Normal} && print(io, "[")

        for node in _children
            show(io, node)
            !isempty(_children) && print(io, ", ")
        end

        p isa Union{Clause, Normal} && print(io, "]")
    end

    print(io, ")")
end

for (T, f) in (
    NullaryOperator => v -> v ? "⊤" : "⊥",
    String => v -> nameof(v ? ⊤ : ⊥),
    Char => v -> v == ⊤ ? "T" : "F",
    Bool => 𝒾,
    Int => Int
)
    @eval formatter(::Type{$T}) = (v, _, _) -> string($f(v))
end

"""
    formatter(t::Type{<:Union{NullaryOperator, String, Char, Bool, Int}})

See also [Nullary Operators](@ref nullary_operators).

| `t`               | `formatter(t)(⊤, _, _)` | `formatter(t)(⊥, _, _)` |
| :---------------- | :---------------------- | :---------------------- |
| `NullaryOperator` | `"⊤"`                   | `"⊥"`                   |
| `String`          | `"tautology"`           | `"contradiction"`       |
| `Char`            | `"T"`                   | `"F"`                   |
| `Bool`            | `"true"`                | `"false"`               |
| `Int`             | `"1"`                   | `"0"`                   |
"""
formatter

___pretty_table(backend::Val{:latex}, io, body; vlines = :all, kwargs...) =
    pretty_table(io, body; backend, vlines, kwargs...)
___pretty_table(backend::Val{:text}, io, body; crop = :none, kwargs...) =
    pretty_table(io, body; backend, crop, kwargs...)

__pretty_table(
    backend::Union{Val{:text}, Val{:latex}}, io, body;
    body_hlines = collect(0:2:size(body, 1)), kwargs...
) = ___pretty_table(backend, io, body; body_hlines, kwargs...)
__pretty_table(backend::Val{:html}, io, body; kwargs...) =
    pretty_table(io, body; backend, kwargs...)

_pretty_table(backend, io, tt; formatters = formatter(NullaryOperator), kwargs...) =
    __pretty_table(backend, io, tt.body; header = tt.header, formatters, kwargs...)

"""
    pretty_table(
        ::Union{IO, Type{Union{String, Docs.HTML}}} = stdout, ::Union{NullaryOperator, Proposition, TruthTable};
        formatters = formatter(NullaryOperator), kwargs...
    )

See also [Nullary Operators](@ref nullary_operators), [`Proposition`](@ref),
[`TruthTable`](@ref), [`formatter`](@ref), and [`PrettyTables.pretty_table`]
(https://ronisbr.github.io/PrettyTables.jl/stable/lib/library/#PrettyTables.pretty_table-Tuple{Any}).

# Examples
```jldoctest
julia> pretty_table(@atomize p ∧ q)
┌───┬───┬───────┐
│ p │ q │ p ∧ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘

julia> print(pretty_table(Docs.HTML, @atomize p ∧ q).content)
<table>
  <thead>
    <tr class = "header headerLastRow">
      <th style = "text-align: left;">p</th>
      <th style = "text-align: left;">q</th>
      <th style = "text-align: left;">p ∧ q</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style = "text-align: left;">⊤</td>
      <td style = "text-align: left;">⊤</td>
      <td style = "text-align: left;">⊤</td>
    </tr>
    <tr>
      <td style = "text-align: left;">⊥</td>
      <td style = "text-align: left;">⊤</td>
      <td style = "text-align: left;">⊥</td>
    </tr>
    <tr>
      <td style = "text-align: left;">⊤</td>
      <td style = "text-align: left;">⊥</td>
      <td style = "text-align: left;">⊥</td>
    </tr>
    <tr>
      <td style = "text-align: left;">⊥</td>
      <td style = "text-align: left;">⊥</td>
      <td style = "text-align: left;">⊥</td>
    </tr>
  </tbody>
</table>
```
"""
pretty_table(io::IO, tt::TruthTable; backend = Val(:text), alignment = :l, kwargs...) =
    _pretty_table(backend, io, tt; alignment, kwargs...)
pretty_table(io::IO, p::Union{NullaryOperator, Proposition}; kwargs...) =
    pretty_table(io, TruthTable((p,)); kwargs...)

"""
    print_tree(::IO = stdout, ::Proposition; kwargs...)

Prints a tree diagram of the given [`Proposition`](@ref).

See also [`AbstractTrees.print_tree`]
(https://github.com/JuliaCollections/AbstractTrees.jl/blob/master/src/printing.jl).

```jldoctest
julia> @atomize print_tree(p ∧ ¬q ⊻ s)
⊻
├─ ∧
│  ├─ 𝒾
│  │  └─ p
│  └─ ¬
│     └─ q
└─ 𝒾
   └─ s

julia> @atomize print_tree(PAndQ.Normal(p ∧ ¬q ⊻ s))
∧
├─ ∨
│  ├─ 𝒾
│  │  └─ p
│  └─ 𝒾
│     └─ s
├─ ∨
│  ├─ ¬
│  │  └─ q
│  └─ 𝒾
│     └─ s
└─ ∨
   ├─ ¬
   │  └─ p
   ├─ 𝒾
   │  └─ q
   └─ ¬
      └─ s
```
"""
print_tree
