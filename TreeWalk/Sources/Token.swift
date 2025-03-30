enum TokenType: CustomStringConvertible {
  // Punctuation
  case leftParen, rightParen, leftBrace, rightBrace
  case comma, dot, semicolon

  // Operators
  case minus, plus, slash, star
  case bang, bangEqual, equal, equalEqual
  case greater, greaterEqual, less, lessEqual

  // Literals
  case identifier(String)
  case string(String)
  case number(Float64)

  // Keywords
  case and, `class`, `else`, `false`, fun, `for`, `if`
  case `nil`, or, print, `return`, `super`, this
  case `true`, `var`, `while`

  case eof

  var description: String {
    switch self {
    case .identifier(let value), .string(let value): value
    case .number(let value): String(value)
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
    case .nil: "nil"
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

struct Token: CustomStringConvertible {
  let type: TokenType
  let line: Int

  var description: String {
    switch type {
    case .identifier, .string, .number: type.description
    default: type.description.uppercased()
    }
  }
}
