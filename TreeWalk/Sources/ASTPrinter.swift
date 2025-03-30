public struct ASTPrinter {
  public init() {}

  public func print(_ expr: Expression) -> String {
    return switch expr {
    case .assign(let name, let value): parenthesize2("=", name.description, value)
    case .binary(let left, let op, let right): parenthesize(op.description, left, right)
    case .call(let callee, _, let arguments): parenthesize2("call", callee, arguments)
    case .get(let object, let name): parenthesize2(".", object, name.description)
    case .grouping(let expression): parenthesize("group", expression)
    case .literal(let value): value.description
    case .logical(let left, let op, let right): parenthesize(op.description, left, right)
    case .set(let object, let name, let value): parenthesize2("=", object, name.description, value)
    case .super(_, let method): parenthesize2("super", method)
    case .this: "this"
    case .unary(let op, let right): parenthesize(op.description, right)
    case .variable(let name): name.description
    }
  }

  private func parenthesize(_ name: String, _ exprs: Expression...) -> String {
    var builder = "(\(name)"

    for expr in exprs {
      builder.append(" ")
      builder.append(print(expr))
    }

    builder.append(")")
    return builder
  }

  private func parenthesize2(_ name: String, _ parts: Any...) -> String {
    var builder = "(\(name)"

    for part in parts {
      builder.append(" ")
      if let expr = part as? Expression {
        builder.append(print(expr))
      } else if let token = part as? Token {
        builder.append(token.description)
      } else if let expressions = part as? [Expression] {
        for expr in expressions {
          builder.append(" ")
          builder.append(print(expr))
        }
      } else {
        builder.append(String(describing: part))
      }
    }

    builder.append(")")
    return builder
  }
}
