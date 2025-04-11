public indirect enum Statement {
  case block(statements: [Statement])
  case `class`(name: Token, superclass: Expression, methods: [Statement])
  case expression(expr: Expression)
  case function(name: Token, params: [Token], body: [Statement])
  case `if`(condition: Expression, thenBranch: Statement, elseBranch: Statement)
  case print(expr: Expression)
  case `return`(keyword: Token, value: Expression)
  case `var`(name: Token, init: Expression?)
  case `while`(condition: Expression, body: Statement)
}
