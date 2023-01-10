var documenterSearchIndex = {"docs":
[{"location":"manual/internals/#Abstract-Types","page":"Internals","title":"Abstract Types","text":"","category":"section"},{"location":"manual/internals/","page":"Internals","title":"Internals","text":"PAQ.Operator\nPAQ.Boolean\nPAQ.Not\nPAQ.And\nPAQ.Or","category":"page"},{"location":"manual/internals/#PAQ.Operator","page":"Internals","title":"PAQ.Operator","text":"Operator\n\nSet of functions that operate on a logical Language.\n\nSupertype of Boolean.\n\n\n\n\n\n","category":"type"},{"location":"manual/internals/#PAQ.Boolean","page":"Internals","title":"PAQ.Boolean","text":"Boolean <: Operator\n\nSet of logical connectives.\n\nSubtype of Operator. Supertype of Not, And, and Or. See also Boolean Operators.\n\n\n\n\n\n","category":"type"},{"location":"manual/internals/#PAQ.Not","page":"Internals","title":"PAQ.Not","text":"Not <: Boolean <: Operator\n\nSingleton type representing logical negation.\n\nSubtype of Boolean and Operator. See also not. ```\n\n\n\n\n\n","category":"type"},{"location":"manual/internals/#PAQ.And","page":"Internals","title":"PAQ.And","text":"And <: Boolean <: Operator\n\nSingleton type representing logical conjunction.\n\nSubtype of Boolean and Operator. See also and. ```\n\n\n\n\n\n","category":"type"},{"location":"manual/internals/#PAQ.Or","page":"Internals","title":"PAQ.Or","text":"Or <: Boolean <: Operator\n\nSingleton type representing logical disjunction.\n\nSubtype of Boolean and Operator. See also or.\n\n\n\n\n\n","category":"type"},{"location":"manual/propositional_logic/#Propositional-Logic","page":"Propositional Logic","title":"Propositional Logic","text":"","category":"section"},{"location":"manual/propositional_logic/","page":"Propositional Logic","title":"Propositional Logic","text":"Language\nCompound\nPrimitive\nLiteral\nPropositional\nNormal\nTruth\ntautology\ncontradiction\nContingency\n@Primitives\nget_primitives","category":"page"},{"location":"manual/propositional_logic/#PAQ.Language","page":"Propositional Logic","title":"PAQ.Language","text":"Language\n\nSet of well-formed logical formulae.\n\nCalling an instance of Language will return a vector of valid interpretations.\n\nSupertype of Primitive, Compound, and Truth. ```\n\n\n\n\n\n","category":"type"},{"location":"manual/propositional_logic/#PAQ.Compound","page":"Propositional Logic","title":"PAQ.Compound","text":"Compound <: Language\n\nCompound proposition.\n\nSubtype of Language. Supertype of Literal, Propositional, and Normal.\n\n\n\n\n\n","category":"type"},{"location":"manual/propositional_logic/#PAQ.Primitive","page":"Propositional Logic","title":"PAQ.Primitive","text":"Primitive <: Language\nPrimitive([statement::String])\n\nPrimitive proposition.\n\ninfo: Info\n\n\nConstructing a Primitive with no argument, an empty string, or an underscore character   will set statement = \"_\". This serves two purposes.   Firstly, it is useful as a default proposition when converting Truths to other forms;   for example: Propositional(⊥) is printed as \"_\" ∧ ¬\"_\".   Secondly, this ensures that pretty-printing does not produce output such as: ``∧ ¬.   It is not idiomatic to use this as a generic proposition; use @Primitives instead.\n\nSubtype of Language.\n\nExamples\n\njulia> p = Primitive(\"p\")\nPrimitive:\n  \"p\"\n\njulia> p()\nContingency:\n  [\"p\" => ⊤] => ⊤\n  [\"p\" => ⊥] => ⊥\n\n\n\n\n\n","category":"type"},{"location":"manual/propositional_logic/#PAQ.Literal","page":"Propositional Logic","title":"PAQ.Literal","text":"Literal{\n    L <: Union{\n        Primitive,\n        Tuple{Not, Primitive}\n    }\n} <: Compound <: Language\nLiteral(p::L)\n\nA Primitive or its negation.\n\nSubtype of Compound and Language. See also Not.\n\nExamples\n\njulia> r = ¬p\nLiteral:\n  ¬\"p\"\n\njulia> r()\nContingency:\n  [\"p\" => ⊤] => ⊥\n  [\"p\" => ⊥] => ⊤\n\n\n\n\n\n","category":"type"},{"location":"manual/propositional_logic/#PAQ.Propositional","page":"Propositional Logic","title":"PAQ.Propositional","text":"Propositional{\n    L <: Union{\n        Tuple{Not, Compound},\n        Tuple{And, Compound, Compound}\n    }\n} <: Compound <: Language\nPropositional(ϕ::L)\n\nAbstract syntax tree representing a compound proposition.\n\nSubtype of Compound and Language. See also Not and And.\n\nExamples\n\njulia> r = p ∧ ¬p\nPropositional:\n  \"p\" ∧ ¬\"p\"\n\njulia> r()\nTruth:\n  ⊥\n\njulia> (p ∧ q)()\nContingency:\n  [\"p\" => ⊤, \"q\" => ⊤] => ⊤\n  [\"p\" => ⊤, \"q\" => ⊥] => ⊥\n  [\"p\" => ⊥, \"q\" => ⊤] => ⊥\n  [\"p\" => ⊥, \"q\" => ⊥] => ⊥\n\n\n\n\n\n","category":"type"},{"location":"manual/propositional_logic/#PAQ.Normal","page":"Propositional Logic","title":"PAQ.Normal","text":"Normal{B <: Union{And, Or}} <: Compound <: Language\nNormal(::Union{typeof(∧), typeof(∨)}, p::Language)\n\nThe conjunctive or disjunctive normal form of a proposition.\n\nConstructing an instance with the parameters ([`and`](@ref), p) and ([`or`](@ref), p) correspond to conjunctive and disjunctive normal form, respectively.\n\nSubtype of Compound and Language.\n\nExamples\n\njulia> r = Normal(∧, p ∧ q)\nNormal:\n  (¬\"p\" ∨ \"q\") ∧ (\"p\" ∨ ¬\"q\") ∧ (\"p\" ∨ \"q\")\n\njulia> s = Normal(∨, ¬p ∨ ¬q)\nNormal:\n  (\"p\" ∧ ¬\"q\") ∨ (¬\"p\" ∧ \"q\") ∨ (¬\"p\" ∧ ¬\"q\")\n\njulia> t = r ∧ s\nPropositional:\n  (¬\"p\" ∨ \"q\") ∧ (\"p\" ∨ ¬\"q\") ∧ (\"p\" ∨ \"q\") ∧ (\"p\" ∧ ¬\"q\") ∨ (¬\"p\" ∧ \"q\") ∨ (¬\"p\" ∧ ¬\"q\")\n\njulia> t()\nTruth:\n  ⊥\n\n\n\n\n\n","category":"type"},{"location":"manual/propositional_logic/#PAQ.Truth","page":"Propositional Logic","title":"PAQ.Truth","text":"Truth{V <: Union{Val{:⊥}, Val{:⊤}}} <: Language\nTruth(::V)\n\nContainer for the constants tautology and contradiction. Subtype of Language.\n\n\n\n\n\n","category":"type"},{"location":"manual/propositional_logic/#PAQ.tautology","page":"Propositional Logic","title":"PAQ.tautology","text":"⊤\ntautology\n\nA constant which is true in every possible interpretation.\n\nOne of two valid instances of Truth, the other instance being contradiction.\n\n⊤ can be typed by \\top<tab>.\n\nExamples\n\njulia> ¬⊤\nTruth:\n  ⊥\n\njulia> tautology()\nTruth:\n  ⊤\n\n\n\n\n\n","category":"constant"},{"location":"manual/propositional_logic/#PAQ.contradiction","page":"Propositional Logic","title":"PAQ.contradiction","text":"⊥\ncontradiction\n\nA constant which is false in every possible interpretation.\n\nOne of two valid instances of Truth, the other instance being tautology.\n\n⊥ can be typed by \\bot<tab>.\n\nExamples\n\njulia> ¬⊥\nTruth:\n  ⊤\n\njulia> contradiction()\nTruth:\n  ⊥\n\n\n\n\n\n","category":"constant"},{"location":"manual/propositional_logic/#PAQ.Contingency","page":"Propositional Logic","title":"PAQ.Contingency","text":"Contingency\n\nExamples\n\njulia> p()\nContingency:\n  [\"p\" => ⊤] => ⊤\n  [\"p\" => ⊥] => ⊥\n\njulia> (p ∧ q)()\nContingency:\n  [\"p\" => ⊤, \"q\" => ⊤] => ⊤\n  [\"p\" => ⊤, \"q\" => ⊥] => ⊥\n  [\"p\" => ⊥, \"q\" => ⊤] => ⊥\n  [\"p\" => ⊥, \"q\" => ⊥] => ⊥\n\n\n\n\n\n","category":"type"},{"location":"manual/propositional_logic/#PAQ.@Primitives","page":"Propositional Logic","title":"PAQ.@Primitives","text":"@Primitives(ps...)\n\nInstantiates Primitive propositions.\n\nExamples\n\njulia> @Primitives p q\n\njulia> p\nPrimitive:\n  \"p\"\n\njulia> q\nPrimitive:\n  \"q\"\n\n\n\n\n\n","category":"macro"},{"location":"manual/propositional_logic/#PAQ.get_primitives","page":"Propositional Logic","title":"PAQ.get_primitives","text":"get_primitives(ps::Language...)\n\nReturns a vector of Primitive propositions contained in ps.\n\nNote that some primitives may optimized out of an expression, such as in p ∧ ⊥.\n\nSee also Language.\n\nExamples\n\njulia> r = p ∧ q\nPropositional:\n  \"p\" ∧ \"q\"\n\njulia> get_primitives(r)\n2-element Vector{Primitive}:\n \"p\"\n \"q\"\n\n\n\n\n\n","category":"function"},{"location":"manual/semantics/#Semantics","page":"Semantics","title":"Semantics","text":"","category":"section"},{"location":"manual/semantics/","page":"Semantics","title":"Semantics","text":"interpret\n==\nis_tautology\nis_contradiction\nis_truth\nis_contingency\nis_satisfiable\nis_falsifiable\n@truth_table","category":"page"},{"location":"manual/semantics/#PAQ.interpret","page":"Semantics","title":"PAQ.interpret","text":"interpret(valuation, p::Language)\n\nGiven a valuation function that maps from the Primitive propositions in p to their respective Truth values, assign a truth value to p.\n\nSee also Language.\n\n\n\n\n\n","category":"function"},{"location":"manual/semantics/#Base.:==","page":"Semantics","title":"Base.:==","text":"p == q\n==(p::Language, q::Language)\nisequal(p::Language, q::Language)\n\nReturns a boolean indicating whether p and q are logically equivalent.\n\nSee also Language.\n\ninfo: Info\nThe ≡ symbol is sometimes used to represent logical equivalence. However, Julia uses ≡ as an alias for the builtin function === which cannot have methods added to it. Use this function to compare identity rather than equivalence.\n\nExamples\n\njulia> p == ¬p\nfalse\n\njulia> (p → q) ∧ (p ← q) == ¬(p ⊻ q)\ntrue\n\njulia> (p → q) ∧ (p ← q) === ¬(p ⊻ q)\nfalse\n\n\n\n\n\n","category":"function"},{"location":"manual/semantics/#PAQ.is_tautology","page":"Semantics","title":"PAQ.is_tautology","text":"is_tautology(p::Language)\n\nReturns a boolean on whether the given proposition is a tautology.\n\nThis function is equivalent to p == ⊤.\n\nSee also Language and ==.\n\nExamples\n\njulia> is_tautology(⊤)\ntrue\n\njulia> is_tautology(p)\nfalse\n\njulia> is_tautology(¬(p ∧ ¬p))\ntrue\n\n\n\n\n\n","category":"function"},{"location":"manual/semantics/#PAQ.is_contradiction","page":"Semantics","title":"PAQ.is_contradiction","text":"is_contradiction(p::Language)\n\nReturns a boolean on whether the given proposition is a contradiction.\n\nThis function is equivalent to p == ⊥.\n\nSee also Language and ==.\n\nExamples\n\njulia> is_contradiction(⊥)\ntrue\n\njulia> is_contradiction(p)\nfalse\n\njulia> is_contradiction(p ∧ ¬p)\ntrue\n\n\n\n\n\n","category":"function"},{"location":"manual/semantics/#PAQ.is_truth","page":"Semantics","title":"PAQ.is_truth","text":"is_truth(p::Language)\n\nReturns a boolean on whether the given proposition is a Truth (either a tautology or contradiction).\n\nSee also Language.\n\nExamples\n\njulia> is_truth(⊤)\ntrue\n\njulia> is_truth(p ∧ ¬p)\ntrue\n\njulia> is_truth(p)\nfalse\n\njulia> is_truth(p ∧ q)\nfalse\n\n\n\n\n\n","category":"function"},{"location":"manual/semantics/#PAQ.is_contingency","page":"Semantics","title":"PAQ.is_contingency","text":"is_contingency(p::Language)\n\nReturns a boolean on whether the given proposition is a contingency (neither a tautology or contradiction).\n\nSee also Language.\n\nExamples\n\njulia> is_contingency(⊤)\nfalse\n\njulia> is_contingency(p ∧ ¬p)\nfalse\n\njulia> is_contingency(p)\ntrue\n\njulia> is_contingency(p ∧ q)\ntrue\n\n\n\n\n\n","category":"function"},{"location":"manual/semantics/#PAQ.is_satisfiable","page":"Semantics","title":"PAQ.is_satisfiable","text":"is_satisfiable(p::Language)\n\nReturns a boolean on whether the given proposition is satisfiable (not a contradiction).\n\nSee also Language.\n\nExamples\n\njulia> is_satisfiable(⊤)\ntrue\n\njulia> is_satisfiable(p ∧ ¬p)\nfalse\n\njulia> is_satisfiable(p)\ntrue\n\njulia> is_satisfiable(p ∧ q)\ntrue\n\n\n\n\n\n","category":"function"},{"location":"manual/semantics/#PAQ.is_falsifiable","page":"Semantics","title":"PAQ.is_falsifiable","text":"is_falsifiable(p::Language)\n\nReturns a boolean on whether the given proposition is falsifiable (not a is_tautology).\n\nSee also Language.\n\nExamples\n\njulia> is_falsifiable(⊥)\ntrue\n\njulia> is_falsifiable(¬(p ∧ ¬p))\nfalse\n\njulia> is_falsifiable(p)\ntrue\n\njulia> is_falsifiable(p ∧ q)\ntrue\n\n\n\n\n\n","category":"function"},{"location":"manual/semantics/#PAQ.@truth_table","page":"Semantics","title":"PAQ.@truth_table","text":"@truth_table p\n@truth_table(ps...)\n\nPrint a truth table for the given propositions.\n\nThe first row of the header is the expression representing that column's proposition, the second row indicates that expression's type, and the third row identifies the statements for Primitive propositions.\n\ninfo: Info\nIf a variable contains a primitive, there is no expression to label that primitive. As such, the first row in the header will be blank. However, the identifying statement is still known and will be displayed in the third row. Use get_primitives to resolve this uncertainty.\n\nLogically equivalent propositions will be placed in the same column with their expressions in the header seperated by a comma.\n\nIn this context, ⊤ and ⊥ can be interpreted as true and false, respectively.\n\nSee also Language.\n\nExamples\n\njulia> @truth_table p ∧ q p → q\n┌───────────┬───────────┬───────────────┬───────────────┐\n│ p         │ q         │ p ∧ q         │ p → q         │\n│ Primitive │ Primitive │ Propositional │ Propositional │\n│ \"p\"       │ \"q\"       │               │               │\n├───────────┼───────────┼───────────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊤             │ ⊤             │\n│ ⊤         │ ⊥         │ ⊥             │ ⊥             │\n├───────────┼───────────┼───────────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊥             │ ⊤             │\n│ ⊥         │ ⊥         │ ⊥             │ ⊤             │\n└───────────┴───────────┴───────────────┴───────────────┘\n\n\n\n\n\n","category":"macro"},{"location":"manual/pretty_printing/#Pretty-Printing","page":"Pretty Printing","title":"Pretty Printing","text":"","category":"section"},{"location":"manual/pretty_printing/","page":"Pretty Printing","title":"Pretty Printing","text":"Pretty\n@Pretty","category":"page"},{"location":"manual/pretty_printing/#PAQ.Pretty","page":"Pretty Printing","title":"PAQ.Pretty","text":"Pretty{L <: Language} <: Language\nPretty(p::L[, text::String])\n\nA wrapper to automatically enable the pretty-printing of p with the contents of text.\n\nThe default value of text will pretty-print p the same as its regular pretty-printing, except without quotation marks.\n\nSee also Language and @Pretty.\n\nExamples\n\njulia> r = p → (q → p)\nPropositional:\n  ¬(\"p\" ∧ \"q\" ∧ ¬\"p\")\n\njulia> Pretty(r)\nPretty{Propositional}:\n  ¬(p ∧ q ∧ ¬p)\n\njulia> Pretty(r, \"p → (q → p)\")\nPretty{Propositional}:\n  p → (q → p)\n\n\n\n\n\n","category":"type"},{"location":"manual/pretty_printing/#PAQ.@Pretty","page":"Pretty Printing","title":"PAQ.@Pretty","text":"@Pretty(expression)\n\nReturn an instance of Pretty, whose text field is set to string(expression).\n\nExamples\n\njulia> p → (q → p)\nPropositional:\n  ¬(\"p\" ∧ \"q\" ∧ ¬\"p\")\n\njulia> @Pretty p → (q → p)\nPretty{Propositional}:\n  p → (q → p)\n\n\n\n\n\n","category":"macro"},{"location":"manual/boolean_operators/","page":"Boolean Operators","title":"Boolean Operators","text":"DocTestSetup = quote\n    using PAQ\n    @Primitives p q\nend","category":"page"},{"location":"manual/boolean_operators/#Boolean-Operators","page":"Boolean Operators","title":"Boolean Operators","text":"","category":"section"},{"location":"manual/boolean_operators/","page":"Boolean Operators","title":"Boolean Operators","text":"Every possible truth table can be constructed with the functionally complete set of operators not and and. For convenience, all sixteen of them have been prepared. There are ten binary operators, with the remaining six being expressed with individual propositions, the unary not operator, and Truth constants.","category":"page"},{"location":"manual/boolean_operators/","page":"Boolean Operators","title":"Boolean Operators","text":"julia> @truth_table ¬p ¬q ⊤ ⊥\n┌───────────┬───────────┬─────────┬─────────┬───────┬───────┐\n│ p         │ q         │ ¬p      │ ¬q      │ ⊤     │ ⊥     │\n│ Primitive │ Primitive │ Literal │ Literal │ Truth │ Truth │\n│ \"p\"       │ \"q\"       │         │         │       │       │\n├───────────┼───────────┼─────────┼─────────┼───────┼───────┤\n│ ⊤         │ ⊤         │ ⊥       │ ⊥       │ ⊤     │ ⊥     │\n│ ⊤         │ ⊥         │ ⊥       │ ⊤       │ ⊤     │ ⊥     │\n├───────────┼───────────┼─────────┼─────────┼───────┼───────┤\n│ ⊥         │ ⊤         │ ⊤       │ ⊥       │ ⊤     │ ⊥     │\n│ ⊥         │ ⊥         │ ⊤       │ ⊤       │ ⊤     │ ⊥     │\n└───────────┴───────────┴─────────┴─────────┴───────┴───────┘","category":"page"},{"location":"manual/boolean_operators/","page":"Boolean Operators","title":"Boolean Operators","text":"Name Symbol Tab completion\nnot ¬ \\neg\nand ∧ \\wedge\nnand ∧ \\nand\nnor ∨ \\nor\nor ∨ \\vee\nxor ⊻ \\xor\nxnor ↔ \\leftrightarrow\nif_then → \\rightarrow\nnot_if_then ↛ \\nrightarrow\nthen_if ← \\leftarrow\nnot_then_if ↚ \\nleftarrow","category":"page"},{"location":"manual/boolean_operators/","page":"Boolean Operators","title":"Boolean Operators","text":"not\nand\nnand\nnor\nor\nxor\nxnor\nif_then\nnot_if_then\nthen_if\nnot_then_if","category":"page"},{"location":"manual/boolean_operators/#PAQ.not","page":"Boolean Operators","title":"PAQ.not","text":"¬p\n¬(p)\nnot(p)\n\nLogical \"negation\" operator.\n\n¬ can be typed by \\neg<tab>.\n\nSee also Not.\n\nExamples\n\njulia> @truth_table ¬p\n┌───────────┬─────────┐\n│ p         │ ¬p      │\n│ Primitive │ Literal │\n│ \"p\"       │         │\n├───────────┼─────────┤\n│ ⊤         │ ⊥       │\n│ ⊥         │ ⊤       │\n└───────────┴─────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#PAQ.and","page":"Boolean Operators","title":"PAQ.and","text":"p ∧ q\n∧(p, q)\nand(p::Language, q::Language)\n\nLogical \"conjunction\" operator.\n\n∧ can be typed by \\wedge<tab>.\n\nSee also And.\n\nExamples\n\njulia> @truth_table p ∧ q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p ∧ q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊤             │\n│ ⊤         │ ⊥         │ ⊥             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊥             │\n│ ⊥         │ ⊥         │ ⊥             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#Base.nand","page":"Boolean Operators","title":"Base.nand","text":"p ⊼ q\n⊼(p, q)\nnand(p, q)\n\nLogical \"non-conjunction\" operator.\n\n⊼ can be typed by \\nand<tab>.\n\nExamples\n\njulia> @truth_table p ⊼ q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p ⊼ q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊥             │\n│ ⊤         │ ⊥         │ ⊤             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊤             │\n│ ⊥         │ ⊥         │ ⊤             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#Base.nor","page":"Boolean Operators","title":"Base.nor","text":"p ⊽ q\n⊽(p, q)\nnor(p, q)\n\nLogical \"non-disjunction\" operator.\n\n⊽ can be typed by \\nor<tab>.\n\nExamples\n\njulia> @truth_table p ⊽ q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p ⊽ q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊥             │\n│ ⊤         │ ⊥         │ ⊥             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊥             │\n│ ⊥         │ ⊥         │ ⊤             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#PAQ.or","page":"Boolean Operators","title":"PAQ.or","text":"p ∨ q\n∨(p, q)\nor(p, q)\n\nLogical \"disjunction\" operator.\n\n∨ can be typed by \\vee<tab>.\n\nExamples\n\njulia> @truth_table p ∨ q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p ∨ q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊤             │\n│ ⊤         │ ⊥         │ ⊤             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊤             │\n│ ⊥         │ ⊥         │ ⊥             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#Base.xor","page":"Boolean Operators","title":"Base.xor","text":"p ⊻ q\n⊻(p, q)\nxor(p, q)\n\nLogical \"exclusive disjunction\" operator.\n\n⊻ can be typed by \\xor<tab>.\n\nExamples\n\njulia> @truth_table p ⊻ q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p ⊻ q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊥             │\n│ ⊤         │ ⊥         │ ⊤             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊤             │\n│ ⊥         │ ⊥         │ ⊥             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#PAQ.xnor","page":"Boolean Operators","title":"PAQ.xnor","text":"p ↔ q\n↔(p, q)\nxnor(p, q)\n\nLogical \"exclusive non-disjunction\" and \"bi-directional implication\" operator.\n\n↔ can be typed by \\leftrightarrow<tab>.\n\nExamples\n\njulia> @truth_table p ↔ q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p ↔ q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊤             │\n│ ⊤         │ ⊥         │ ⊥             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊥             │\n│ ⊥         │ ⊥         │ ⊤             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#PAQ.if_then","page":"Boolean Operators","title":"PAQ.if_then","text":"p → q\n→(p, q)\nif_then(p, q)\n\nLogical \"implication\" operator.\n\n→ can be typed by \\rightarrow<tab>.\n\nExamples\n\njulia> @truth_table p → q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p → q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊤             │\n│ ⊤         │ ⊥         │ ⊥             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊤             │\n│ ⊥         │ ⊥         │ ⊤             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#PAQ.not_if_then","page":"Boolean Operators","title":"PAQ.not_if_then","text":"p ↛ q\n↛(p, q)\nnot_if_then(p, q)\n\nLogical \"non-implication\" operator.\n\n↛ can be typed by \\nrightarrow<tab>.\n\nExamples\n\njulia> @truth_table p ↛ q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p ↛ q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊥             │\n│ ⊤         │ ⊥         │ ⊤             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊥             │\n│ ⊥         │ ⊥         │ ⊥             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#PAQ.then_if","page":"Boolean Operators","title":"PAQ.then_if","text":"p ← q\n←(p, q)\nthen_if(p, q)\n\nLogical \"converse implication\" operator.\n\n← can be typed by \\leftarrow<tab>.\n\nExamples\n\njulia> @truth_table p ← q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p ← q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊤             │\n│ ⊤         │ ⊥         │ ⊤             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊥             │\n│ ⊥         │ ⊥         │ ⊤             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"manual/boolean_operators/#PAQ.not_then_if","page":"Boolean Operators","title":"PAQ.not_then_if","text":"p ↚ q\n↚(p, q)\nnot_then_if(p, q)\n\nLogical \"converse non-implication\" operator.\n\n↚ can be typed by \\nleftarrow<tab>.\n\nExamples\n\njulia> @truth_table p ↚ q\n┌───────────┬───────────┬───────────────┐\n│ p         │ q         │ p ↚ q         │\n│ Primitive │ Primitive │ Propositional │\n│ \"p\"       │ \"q\"       │               │\n├───────────┼───────────┼───────────────┤\n│ ⊤         │ ⊤         │ ⊥             │\n│ ⊤         │ ⊥         │ ⊥             │\n├───────────┼───────────┼───────────────┤\n│ ⊥         │ ⊤         │ ⊤             │\n│ ⊥         │ ⊥         │ ⊥             │\n└───────────┴───────────┴───────────────┘\n\n\n\n\n\n","category":"function"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = quote\n    using PAQ\nend","category":"page"},{"location":"#Home","page":"Home","title":"Home","text":"","category":"section"},{"location":"#Introduction","page":"Home","title":"Introduction","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"If you like propositional logic, then you've come to the right place!","category":"page"},{"location":"","page":"Home","title":"Home","text":"P∧Q has an intuitive interface that enables you to manipulate logical statements symbolically. The implementation is concise, only ~200 source lines of code (according to Codecov as of December, 2022).","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> import Pkg\n\njulia> Pkg.add(url = \"https://github.com/jakobjpeters/PAQ.jl\")\n\njulia> using PAQ","category":"page"},{"location":"#Showcase","page":"Home","title":"Showcase","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> ¬⊥\nTruth:\n  ⊤\n\njulia> @Primitives p q\n\njulia> r = p ∧ q\nPropositional:\n  \"p\" ∧ \"q\"\n\njulia> r()\nContingency:\n  [\"p\" => ⊤, \"q\" => ⊤] => ⊤\n  [\"p\" => ⊤, \"q\" => ⊥] => ⊥\n  [\"p\" => ⊥, \"q\" => ⊤] => ⊥\n  [\"p\" => ⊥, \"q\" => ⊥] => ⊥\n\njulia> s = Pretty(Normal(∧, r))\nPretty{Normal}:\n  (¬p ∨ q) ∧ (p ∨ ¬q) ∧ (p ∨ q)\n\njulia> t = @Pretty p ⊻ q\nPretty{Propositional}:\n  p ⊻ q\n\njulia> @truth_table p ⊻ q s ⊥\n┌───────────┬───────────┬───────────────┬────────┬───────┐\n│ p         │ q         │ p ⊻ q         │ s      │ ⊥     │\n│ Primitive │ Primitive │ Propositional │ Normal │ Truth │\n│ \"p\"       │ \"q\"       │               │        │       │\n├───────────┼───────────┼───────────────┼────────┼───────┤\n│ ⊤         │ ⊤         │ ⊥             │ ⊤      │ ⊥     │\n│ ⊤         │ ⊥         │ ⊤             │ ⊥      │ ⊥     │\n├───────────┼───────────┼───────────────┼────────┼───────┤\n│ ⊥         │ ⊤         │ ⊤             │ ⊥      │ ⊥     │\n│ ⊥         │ ⊥         │ ⊥             │ ⊥      │ ⊥     │\n└───────────┴───────────┴───────────────┴────────┴───────┘","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"DocTestSetup = quote\n    using PAQ\n    @Primitives p q\nend","category":"page"},{"location":"tutorial/#Tutorial","page":"Tutorial","title":"Tutorial","text":"","category":"section"},{"location":"tutorial/#Propositional-Logic","page":"Tutorial","title":"Propositional Logic","text":"","category":"section"},{"location":"tutorial/#Primitive-Propositions","page":"Tutorial","title":"Primitive Propositions","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"A primitive proposition is a statement that can be true or false. For example, the statement \"Logic is fun\" may be true for you but false for someone else. Primitive propositions can be expressed as:","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"julia> p = Primitive(\"Logic is fun\")\nPrimitive:\n  \"Logic is fun\"\n\njulia> q = Primitive(\"Julia is awesome\")\nPrimitive:\n  \"Julia is awesome\"","category":"page"},{"location":"tutorial/#Compound-Propositions","page":"Tutorial","title":"Compound Propositions","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Since p can be true or false, we can form other logical statements that depends on p's truth value. These statements use logical connectives and are called Compound propositions. To express the proposition that \"Logic is not fun\", use the logical not connective: not(p) or ¬p.  If p's truth value is true, then ¬p's truth value is false, and vice versa. A helpful tool to check a statement's truth values is @truth_table.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"julia> @truth_table ¬p\n┌───────────┬─────────┐\n│ p         │ ¬p      │\n│ Primitive │ Literal │\n│ \"p\"       │         │\n├───────────┼─────────┤\n│ ⊤         │ ⊥       │\n│ ⊥         │ ⊤       │\n└───────────┴─────────┘","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"info: Info\nFor now, think of the symbols ⊤ and ⊥ as true and false, respectively. An exact definition of them will be given in a couple of paragraphs.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Statements can also depend on multiple primitive propositions. The logical and connective is true when both p and q are true and is false otherwise. This is expressed as and(p, q), ∧(p, q), or p ∧ q. Repeatedly combining the connectives not and and can produce any possible truth table. As such, they are referred to as functionally complete. For example, the connective or is equivalent to ¬(¬p ∧ ¬q).","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"julia> @truth_table or(p, q) ¬(¬p ∧ ¬q)\n┌───────────┬───────────┬──────────────────────┐\n│ p         │ q         │ or(p, q), ¬(¬p ∧ ¬q) │\n│ Primitive │ Primitive │ Propositional        │\n│ \"p\"       │ \"q\"       │                      │\n├───────────┼───────────┼──────────────────────┤\n│ ⊤         │ ⊤         │ ⊤                    │\n│ ⊤         │ ⊥         │ ⊤                    │\n├───────────┼───────────┼──────────────────────┤\n│ ⊥         │ ⊤         │ ⊤                    │\n│ ⊥         │ ⊥         │ ⊥                    │\n└───────────┴───────────┴──────────────────────┘","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"info: Info\nThe first two cells of each row in this table is an interpretation, which allows the truth value of the corresponding last cell to be determined. More generally, interpretations are an assignment of meaning to logical symbols. A function that maps logical symbols or formulae to their meaning is called a valuation function.","category":"page"},{"location":"tutorial/#Truth-Values","page":"Tutorial","title":"Truth Values","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Consider the proposition p ∧ ¬p. Using the earlier example, this states that both \"Logic is fun\" and \"Logic is not fun\". Since these statements are mutually exclusive, their conjunction forms a contradiction. A contradiction is a statement that is false in every possible interpretation. In other words, the statement p ∧ ¬p is false regardless of whether p's truth value is true or false. A contradiction can be expressed as contradiction or with the symbol ⊥. The negation of a contradiction, in this case ¬(p ∧ ¬p), results in a statement that is true in every possible interpretation. This is called a tautology and can be expressed as tautology or with the symbol ⊤. Contradiction and tautology symbols are also be used to express the concepts of true and false, respectively.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"info: Info\nNote that ⊤ is a Unicode symbol, not an uppercase \"t\". The documentation for each symbol provides instructions on how to type it. For example, ⊤ can be typed by \\top<tab>. See also Julia's documentation on Unicode Input.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"julia> ¬⊥\nTruth:\n  ⊤\n\njulia> p ∧ ⊤ # identity law\nPrimitive:\n  \"p\"\n\njulia> p ∧ ⊥ # domination law\nTruth:\n  ⊥","category":"page"},{"location":"tutorial/#Implementation","page":"Tutorial","title":"Implementation","text":"","category":"section"},{"location":"tutorial/#Types","page":"Tutorial","title":"Types","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"import AbstractTrees: children # hide\nusing AbstractTrees: print_tree # hide\nusing InteractiveUtils: subtypes # hide\nusing PAQ: Language # hide\n\nchildren(x::Type) = subtypes(x) # hide\nprint_tree(Language) # hide","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"In Backus-Naur Form (BNF), Propositional is defined \"inductively\" as:","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"p ::= q | ¬ϕ | ϕ ∧ ϕ","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Since we may want to refer to compound statements defined differently, ϕ has the abstract type Compound rather than being a Propositional.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Remember, every infix operator is a function. They also each have a written alias.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"julia> p ∧ q === ∧(p, q) === and(p, q)\ntrue","category":"page"},{"location":"tutorial/#Minimization","page":"Tutorial","title":"Minimization","text":"","category":"section"},{"location":"tutorial/#Logically-Equivalent-Representations","page":"Tutorial","title":"Logically Equivalent Representations","text":"","category":"section"},{"location":"tutorial/#Order-of-Operations","page":"Tutorial","title":"Order of Operations","text":"","category":"section"},{"location":"tutorial/#Associativity","page":"Tutorial","title":"Associativity","text":"","category":"section"}]
}
