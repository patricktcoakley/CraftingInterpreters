public enum LoxValue: CustomStringConvertible {
  case `nil`
  case boolean(Bool)
  case number(Double)
  case string(String)

  var isTruthy: Bool {
    return switch self {
    case .nil: false
    case let .boolean(bool): bool
    default: true
    }
  }

  public var description: String {
    switch self {
    case .nil: return "nil"
    case let .boolean(bool): return bool ? "true" : "false"
    case let .number(num): return String(num)
    case let .string(str): return str
    }
  }
}

extension LoxValue: Equatable {
  public static func == (lhs: LoxValue, rhs: LoxValue) -> Bool {
    switch (lhs, rhs) {
    case (.nil, .nil): true
    case (.nil, _), (_, .nil): false
    case let (.boolean(a), .boolean(b)): a == b
    case let (.number(a), .number(b)): a == b
    case let (.string(a), .string(b)): a == b
    default: false
    }
  }
}

public indirect enum Expression {
  case assign(name: Token, value: Expression)
  case binary(left: Expression, operator: Token, right: Expression)
  case call(callee: Expression, paren: Token, arguments: [Expression])
  case get(object: Expression, name: Token)
  case grouping(expression: Expression)
  case literal(value: LoxValue)
  case logical(left: Expression, operator: Token, right: Expression)
  case set(object: Expression, name: Token, value: Expression)
  case `super`(keyword: Token, method: Token)
  case this(keyword: Token)
  case unary(operator: Token, right: Expression)
  case variable(name: Token)
}
