public indirect enum Expression {
  case assign(name: Token, value: Expression)
  case binary(left: Expression, operator: Token, right: Expression)
  case call(callee: Expression, paren: Token, arguments: [Expression])
  case get(object: Expression, name: Token)
  case grouping(expression: Expression)
  case literal(value: Literal)
  case logical(left: Expression, operator: Token, right: Expression)
  case set(object: Expression, name: Token, value: Expression)
  case `super`(keyword: Token, method: Token)
  case this(keyword: Token)
  case unary(operator: Token, right: Expression)
  case variable(name: Token)
}
