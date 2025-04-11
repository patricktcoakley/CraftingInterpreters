class Interpreter {
  private var environment = Environment()

  public func interpret(_ statements: [Statement]) {
    do {
      for statement in statements {
        try execute(statement)
      }
    } catch {
      print(error)
    }
  }

  public func evaluate(_ expression: Expression) throws(RuntimeError) -> LoxValue {
    switch expression {
    case let .literal(value: value):
      switch value {
      case let .boolean(value): return .boolean(value)
      case let .number(value): return .number(value)
      case let .string(value): return .string(value)
      case .nil: return .nil
      }

    case let .variable(name: name):
      if case let .identifier(identifierName) = name.type {
        return try environment.get(identifierName)
      }
      throw RuntimeError(name, "Expected a variable.")

    case let .grouping(expression: expr):
      return try evaluate(expr)

    case let .unary(operator: op, right: right):
      let right = try evaluate(right)
      switch op.type {
      case .bang: return .boolean(!right.isTruthy)
      case .minus:
        guard case let .number(num) = right else {
          throw RuntimeError(op, "Operand must be a number.")
        }
        return .number(-num)
      default:
        throw RuntimeError(op, "Unknown unary operator.")
      }

    case let .binary(left: left, operator: op, right: right):
      let lhs = try evaluate(left)
      let rhs = try evaluate(right)

      switch op.type {
      case .minus:
        if case let .number(a) = lhs, case let .number(b) = rhs {
          return .number(a - b)
        } else { fatalError("Unreachable after type check.") }

      case .star:
        if case let .number(a) = lhs, case let .number(b) = rhs {
          return .number(a * b)
        } else { fatalError("Unreachable after type check.") }

      case .slash:
        if case let .number(a) = lhs, case let .number(b) = rhs {
          guard b != 0 else { throw RuntimeError(op, "Division by zero.") }
          return .number(a / b)
        } else { fatalError("Unreachable after type check") }

      case .plus:
        if case let .number(a) = lhs, case let .number(b) = rhs {
          return .number(a + b)
        } else if case let .string(a) = lhs, case let .string(b) = rhs {
          return .string(a + b)
        } else {
          throw RuntimeError(op, "Operands must be two numbers or two strings.")
        }

      default:
        throw RuntimeError(op, "Unknown binary operator.")
      }

    case let .assign(name, value):
      let valueToAssign = try evaluate(value)
      return try environment.assign(name.description, valueToAssign)

    default:
      throw RuntimeError(Token(type: .eof, line: 0), "Unsupported expression type")
    }
  }

  public func execute(_ statement: Statement) throws(RuntimeError) {
    switch statement {
    case let .print(expr: expr):
      try print(evaluate(expr))

    case let .expression(expr: expr):
      _ = try evaluate(expr)

    case let .block(statements):
      try executeBlock(statements, Environment())

    case let .var(name: name, init: initializer):
      var value: LoxValue = .nil
      if let initializer = initializer {
        value = try evaluate(initializer)
      }
      if case let .identifier(identifierName) = name.type {
        environment.define(identifierName, value)
      } else {
        throw RuntimeError(name, "Expected variable name.")
      }

    default:
      fatalError("Unsupported statement type.")
    }
  }

  public func executeBlock(_ statements: [Statement], _ environment: Environment) throws(RuntimeError) {
    let prev = self.environment
    defer {
      self.environment = prev
    }

    self.environment = environment

    for statement in statements {
      try execute(statement)
    }
  }
}
