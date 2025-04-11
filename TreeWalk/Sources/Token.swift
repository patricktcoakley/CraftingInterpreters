public enum TokenType: Equatable, CustomStringConvertible, Sendable {
  // Punctuation
  case leftParen, rightParen, leftBrace, rightBrace
  case comma, dot, semicolon

  // Operators
  case minus, plus, slash, star
  case bang, bangEqual, equal, equalEqual
  case greater, greaterEqual, less, lessEqual

  // Literal
  case string(String)
  case number(Float64)
  case boolean(Bool)
  case identifier(String)
  case `nil`

  // Keywords
  case and, `class`, `else`, `false`, fun, `for`, `if`
  case or, print, `return`, `super`, this
  case `true`, `var`, `while`

  case eof

  public var description: String {
    switch self {
    case let .string(value): "\"\(value)\""
    case let .number(value):
      // String representation as Int if possible
      if let anInt = Int(exactly: value) {
        String(anInt)
      } else {
        String(value)
      }
    case let .boolean(value): value ? "true" : "false"
    case let .identifier(value): value
    case .nil: "nil" case .leftParen: "("
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

public struct Token: Equatable, CustomStringConvertible, Sendable {
  public let type: TokenType
  public let line: Int

  public init(type: TokenType, line: Int) {
    self.type = type
    self.line = line
  }

  public var description: String {
    switch type {
    case .string, .number, .boolean, .identifier, .nil
         : type.description
    default: type.description.uppercased()
    }
  }

  public static func == (lhs: Token, rhs: Token) -> Bool {
    lhs.line == rhs.line && lhs.type == rhs.type
  }
}
