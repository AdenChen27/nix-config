if !has('conceal') | finish | endif

" Annotation command and environment highlights
syntax match texCmdDraftnote "\%#=1\\draftnote\>"
syntax match texEnvItodo /\<itodo\>/ contained containedin=texEnvArgName
highlight def link texCmdDraftnote VimtexTodo
highlight def link texEnvItodo VimtexTodo

" Superscript complement
syntax match texMathSymbol /\^\s*\\complement\>/ contained conceal cchar=ᶜ

" Colon operators (mathtools single-= variants not in VimTeX table)
syntax match texMathSymbol /\\coloneq\>/ contained conceal cchar=≔
syntax match texMathSymbol /\\eqcolon\>/ contained conceal cchar=≕

" Greek aliases from adenc.sty
syntax match texMathSymbol /\\eps\>/  contained conceal cchar=ε
syntax match texMathSymbol /\\vphi\>/ contained conceal cchar=φ

" Proof symbols
syntax match texMathSymbol /\\qed\(here\)\?\>/ conceal cchar=□

" Probability / statistics
syntax match texMathSymbol /\\indep\>/ contained conceal cchar=⫫
syntax match texMathSymbol /\\ind\>/   contained conceal cchar=𝟙

" Blackboard bold (double-struck)
syntax match texMathSymbol /\\Pr\>/  contained conceal cchar=ℙ
syntax match texMathSymbol /\\E\>/   contained conceal cchar=𝔼
syntax match texMathSymbol /\\Var\>/ contained conceal cchar=𝕍
syntax match texMathSymbol /\\bV\>/  contained conceal cchar=𝕍
syntax match texMathSymbol /\\bR\>/  contained conceal cchar=ℝ
syntax match texMathSymbol /\\bN\>/  contained conceal cchar=ℕ
syntax match texMathSymbol /\\bZ\>/  contained conceal cchar=ℤ
syntax match texMathSymbol /\\bQ\>/  contained conceal cchar=ℚ
syntax match texMathSymbol /\\bS\>/  contained conceal cchar=𝕊
syntax match texMathSymbol /\\bT\>/  contained conceal cchar=𝕋

" Mathcal (script)
syntax match texMathSymbol /\\cA\>/ contained conceal cchar=𝒜
syntax match texMathSymbol /\\cB\>/ contained conceal cchar=ℬ
syntax match texMathSymbol /\\cC\>/ contained conceal cchar=𝒞
syntax match texMathSymbol /\\cD\>/ contained conceal cchar=𝒟
syntax match texMathSymbol /\\cE\>/ contained conceal cchar=ℰ
syntax match texMathSymbol /\\cF\>/ contained conceal cchar=ℱ
syntax match texMathSymbol /\\cG\>/ contained conceal cchar=𝒢
syntax match texMathSymbol /\\cH\>/ contained conceal cchar=ℋ
syntax match texMathSymbol /\\cI\>/ contained conceal cchar=ℐ
syntax match texMathSymbol /\\cJ\>/ contained conceal cchar=𝒥
syntax match texMathSymbol /\\cK\>/ contained conceal cchar=𝒦
syntax match texMathSymbol /\\cL\>/ contained conceal cchar=ℒ
syntax match texMathSymbol /\\cM\>/ contained conceal cchar=ℳ
syntax match texMathSymbol /\\cN\>/ contained conceal cchar=𝒩
syntax match texMathSymbol /\\cO\>/ contained conceal cchar=𝒪
syntax match texMathSymbol /\\cP\>/ contained conceal cchar=𝒫
syntax match texMathSymbol /\\cQ\>/ contained conceal cchar=𝒬
syntax match texMathSymbol /\\cR\>/ contained conceal cchar=ℛ
syntax match texMathSymbol /\\cS\>/ contained conceal cchar=𝒮
syntax match texMathSymbol /\\cT\>/ contained conceal cchar=𝒯
syntax match texMathSymbol /\\cU\>/ contained conceal cchar=𝒰
syntax match texMathSymbol /\\cV\>/ contained conceal cchar=𝒱
syntax match texMathSymbol /\\cW\>/ contained conceal cchar=𝒲
syntax match texMathSymbol /\\cX\>/ contained conceal cchar=𝒳
syntax match texMathSymbol /\\cY\>/ contained conceal cchar=𝒴
syntax match texMathSymbol /\\cZ\>/ contained conceal cchar=𝒵
