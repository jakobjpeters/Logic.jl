
import AbstractTrees: print_tree
import Base: Stateful, show
import PrettyTables: pretty_table
using AbstractTrees: print_child_key
using Base.Docs: HTML

"""
    TruthTable(::Vector{String}, ::Matrix{Bool})
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

julia> @atomize TruthTable([p ∧ ¬p, p → q, ¬p ∨ q])
┌────────┬───┬───┬───────────────┐
│ p ∧ ¬p │ p │ q │ p → q, ¬p ∨ q │
├────────┼───┼───┼───────────────┤
│ ⊥      │ ⊤ │ ⊤ │ ⊤             │
│ ⊥      │ ⊥ │ ⊤ │ ⊤             │
├────────┼───┼───┼───────────────┤
│ ⊥      │ ⊤ │ ⊥ │ ⊥             │
│ ⊥      │ ⊥ │ ⊥ │ ⊤             │
└────────┴───┴───┴───────────────┘
```
"""
struct TruthTable
    header::Vector{String}
    body::Matrix{Bool}
end

function TruthTable(ps)
    ps = map(p -> p isa Proposition ? p : Tree(p), ps)
    _atoms = unique(Iterators.flatmap(atoms, ps))
    ps = union(_atoms, ps)
    _valuations = valuations(_atoms)
    _interpretations = Iterators.map(p -> vec(map(
        valuation -> Bool(interpret(a -> Dict(valuation)[a], normalize(¬, p))),
    _valuations)), ps)

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

    TruthTable(header, reduce(hcat, body))
end

# Internals

# `show`

"""
    show(::IO, ::MIME"text/plain", ::Operator)

Represent the given [`Operator`](@ref) as specified by [`symbol_of`](@ref Interface.symbol_of)
"""
show(io::IO, ::MIME"text/plain", o::Operator) = print(io, symbol_of(o))

"""
    show(::IO, ::MIME"text/plain", ::Proposition)

Represent the given [`Proposition`](@ref) as a [propositional formula]
(https://en.wikipedia.org/wiki/Propositional_formula).

The value of a [`Constant`](@ref PAndQ.Constant) is shown with an `IOContext` whose
`:compact` and `:limit` keys are individually set to `true` if they have not already been set.

# Examples
```jldoctest
julia> @atomize show(stdout, MIME"text/plain"(), p ∧ q)
p ∧ q

julia> @atomize show(stdout, MIME"text/plain"(), (p ∨ q) ∧ (r ∨ s))
(p ∨ q) ∧ (r ∨ s)
```
"""
show(io::IO, ::MIME"text/plain", p::Proposition) =
    _show_proposition(IOContext(io, :root => true, map(key -> key => get(io, key, true), (:compact, :limit))...), p)

"""
    show(::IO, ::MIME"text/plain", ::TruthTable)

Represent the [`TruthTable`](@ref) in its default format.

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

function __show(f, g, io, ps)
    qs, root = Stateful(ps), get(io, :root, true)
    root || print(io, "(")
    for q in qs
        g(io, q)
        isempty(qs) || f(io)
    end
    if !root print(io, ")") end
end

"""
    show(::IO, ::Proposition)

Represent the [`Proposition`](@ref PAndQ.Proposition) verbosely.

# Examples
```jldoctest
julia> @atomize show(stdout, p ∧ q)
and(PAndQ.Variable(:p), PAndQ.Variable(:q))

julia> and(PAndQ.Variable(:p), PAndQ.Variable(:q))
p ∧ q
```
"""
function show(io::IO, p::Atom)
    print(io, typeof(p), "(")
    show(io, getfield(p, 1))
    print(io, ")")
end
show(io::IO, p::Tree{typeof(𝒾)}) = show(io, child(p))
function show(io::IO, p::Tree)
    o = nodevalue(p)
    print(io, name_of(o), "(")
    __show(io -> print(io, ", "), show, io, children(p))
    print(io, ")")
end

for (T, f) in (
    NullaryOperator => v -> v ? "⊤" : "⊥",
    String => v -> nameof(v ? "tautology" : "contradiction"),
    Char => v -> v == ⊤ ? "T" : "F",
    Bool => 𝒾,
    Int => Int
)
    @eval formatter(::Type{$T}) = (v, _, _) -> string($f(v))
end

"""
    formatter(type)

Use as the `formatters` keyword argument in [`pretty_table`](@ref).

| `type`            | `formatter(type)(true, _, _)` | `formatter(type)(false, _, _)` |
| :---------------- | :---------------------------- | :----------------------------- |
| `NullaryOperator` | `"⊤"`                         | `"⊥"`                          |
| `String`          | `"tautology"`                 | `"contradiction"`              |
| `Char`            | `"T"`                         | `"F"`                          |
| `Bool`            | `"true"`                      | `"false"`                      |
| `Int`             | `"1"`                         | `"0"`                          |

See also [Nullary Operators](@ref nullary_operators).

# Examples
```jldoctest
julia> @atomize pretty_table(p ∧ q; formatters = formatter(Int))
┌───┬───┬───────┐
│ p │ q │ p ∧ q │
├───┼───┼───────┤
│ 1 │ 1 │ 1     │
│ 0 │ 1 │ 0     │
├───┼───┼───────┤
│ 1 │ 0 │ 0     │
│ 0 │ 0 │ 0     │
└───┴───┴───────┘
```
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
__pretty_table(backend::Union{Val{:markdown}, Val{:html}}, io, body; kwargs...) =
    pretty_table(io, body; backend, kwargs...)

_pretty_table(backend, io, tt; formatters = formatter(NullaryOperator), kwargs...) =
    __pretty_table(backend, io, tt.body; header = tt.header, formatters, kwargs...)

"""
    pretty_table(
        ::Union{IO, Type{<:Union{String, Docs.HTML}}} = stdout,
        ::Union{NullaryOperator, Proposition, TruthTable};
        formatters = formatter(NullaryOperator),
        kwargs...
    )

See also [Nullary Operators](@ref nullary_operators), [`Proposition`](@ref),
[`TruthTable`](@ref), [`formatter`](@ref), and [`PrettyTables.pretty_table`]
(https://ronisbr.github.io/PrettyTables.jl/stable/lib/library/#PrettyTables.pretty_table-Tuple{Any}).

# Examples
```jldoctest
julia> @atomize pretty_table(p ∧ q)
┌───┬───┬───────┐
│ p │ q │ p ∧ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘

julia> @atomize pretty_table(p ∧ q; backend = Val(:markdown))
| **p** | **q** | **p ∧ q** |
|:------|:------|:----------|
| ⊤     | ⊤     | ⊤         |
| ⊥     | ⊤     | ⊥         |
| ⊤     | ⊥     | ⊥         |
| ⊥     | ⊥     | ⊥         |

julia> @atomize print(pretty_table(String, p ∧ q; backend = Val(:html)))
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
julia> @atomize print_tree(p ∧ q ∨ ¬s)
∨
├─ ∧
│  ├─ 𝒾
│  │  └─ p
│  └─ 𝒾
│     └─ q
└─ ¬
   └─ s

julia> @atomize print_tree(normalize(∧, p ∧ q ∨ ¬s))
∧
├─ ∨
│  ├─ ¬
│  │  └─ s
│  └─ 𝒾
│     └─ p
└─ ∨
   ├─ ¬
   │  └─ s
   └─ 𝒾
      └─ q
```
"""
print_tree
