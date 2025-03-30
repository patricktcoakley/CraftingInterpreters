public enum Literal: Equatable, CustomStringConvertible {
  case string(String)
  case number(Float64)
  case boolean(Bool)
  case identifier(String)
  case `nil`

  public var description: String {
    return switch self {
    case .string(let value): "\"\(value)\""
    case .number(let value):
      // String representation as Int if possible
      if let anInt = Int(exactly: value) {
        String(anInt)
      } else {
        String(value)
      }
    case .boolean(let value): value ? "true" : "false"
    case .identifier(let value): value
    case .nil: "nil"
    }
  }
}

public enum TokenType: CustomStringConvertible {
  // Punctuation
  case leftParen, rightParen, leftBrace, rightBrace
  case comma, dot, semicolon

  // Operators
  case minus, plus, slash, star
  case bang, bangEqual, equal, equalEqual
  case greater, greaterEqual, less, lessEqual

  // Literal
  case literal(Literal)

  // Keywords
  case and, `class`, `else`, `false`, fun, `for`, `if`
  case or, print, `return`, `super`, this
  case `true`, `var`, `while`

  case eof

  public var description: String {
    switch self {
    case .literal(let value): value.description
    case .leftParen: "("
    case .rightParen: ")"
    case .leftBrace: "{"
    case .rightBrace: "}"
    case .comma: ","
    case .dot: "."
    case .minus: "-"
    case .plus: "+"
    case .semicolon: ";"
    case .slash: "/"
    case .star: "*"
    case .bang: "!"
    case .bangEqual: "!="
    case .equal: "="
    case .equalEqual: "=="
    case .greater: ">"
    case .greaterEqual: ">="
    case .less: "<"
    case .lessEqual: "<="
    case .and: "and"
    case .class: "class"
    case .else: "else"
    case .false: "false"
    case .fun: "fun"
    case .for: "for"
    case .if: "if"
    case .or: "or"
    case .print: "print"
    case .return: "return"
    case .super: "super"
    case .this: "this"
    case .true: "true"
    case .var: "var"
    case .while: "while"
    case .eof: "EOF"
    }
  }
}

public struct Token: CustomStringConvertible {
  public let type: TokenType
  public let line: Int

  public init(type: TokenType, line: Int) {
    self.type = type
    self.line = line
  }

  public var description: String {
    switch type {
    case .literal: type.description
    default: type.description.uppercased()
    }
  }
}
