public class Parser {
  private var tokens: [Token]
  private var current = 0
  private var errors: [ParserError] = []

  public init(tokens: [Token]) {
    self.tokens = tokens
  }

  public func parse() throws(ParserError) -> [Statement] {
    var statements: [Statement] = []

    while !isAtEnd {
      if let stmt = try declaration() {
        statements.append(stmt)
      }
    }

    return statements
  }

  private func expression() throws(ParserError) -> Expression {
    return try assignment()
  }

  private func assignment() throws(ParserError) -> Expression {
    let expr = try equality()

    if match(.equal) {
      let equals = previous
      let value = try assignment()

      if case let .variable(name) = expr {
        return .assign(name: name, value: value)
      }

      throw ParserError.invalid(token: equals)
    }

    return expr
  }

  private func statement() throws(ParserError) -> Statement {
    if match(.print) {
      return try printStatement()
    }

    if match(.leftBrace) {
      return try .block(statements: block())
    }

    return try expressionStatement()
  }

  private func block() throws(ParserError) -> [Statement] {
    var statements: [Statement] = []

    while !match(.rightBrace), !isAtEnd {
      if let decl = try declaration() {
        statements.append(decl)
      }
    }

    _ = try chomp(.rightBrace, "Expect '}' after block.")

    return statements
  }

  private func printStatement() throws(ParserError) -> Statement {
    let val = try expression()
    _ = try chomp(.semicolon, "Expect ';' after value.")
    return .print(expr: val)
  }

  private func expressionStatement() throws(ParserError) -> Statement {
    let expr = try expression()
    _ = try chomp(.semicolon, "Expect ';' after expression.")
    return .expression(expr: expr)
  }

  private func declaration() throws(ParserError) -> Statement? {
    do {
      guard !match(.var) else { return try varDeclaration() }

      return try statement()
    } catch {
      synchronize()
      return nil
    }
  }

  private func varDeclaration() throws -> Statement {
    let name = try chompIdentifier()

    var initializer: Expression?
    if match(.equal) {
      initializer = try expression()
    }

    _ = try chomp(.semicolon, "Expect ';' after variable declaration.")
    return .var(name: name, init: initializer)
  }

  private func equality() throws(ParserError) -> Expression {
    var left = try comparison()

    while match(.bangEqual, .equalEqual) {
      let op = previous
      let right = try comparison()
      left = .binary(left: left, operator: op, right: right)
    }

    return left
  }

  private func comparison() throws(ParserError) -> Expression {
    var left = try term()

    while match(.greater, .greaterEqual, .less, .lessEqual) {
      let op = previous
      let right = try term()
      left = .binary(left: left, operator: op, right: right)
    }

    return left
  }

  private func term() throws(ParserError) -> Expression {
    var left = try factor()

    while match(.minus, .plus) {
      let op = previous
      let right = try factor()
      left = .binary(left: left, operator: op, right: right)
    }

    return left
  }

  private func factor() throws(ParserError) -> Expression {
    var left = try unary()

    while match(.slash, .star) {
      let op = previous
      let right = try unary()
      left = .binary(left: left, operator: op, right: right)
    }

    return left
  }

  private func unary() throws(ParserError) -> Expression {
    if match(.bang, .minus) {
      let op = previous
      let right = try unary()
      return .unary(operator: op, right: right)
    }

    return try primary()
  }

  private func primary() throws(ParserError) -> Expression {
    if match(.false) { return .literal(value: .boolean(false)) }
    if match(.true) { return .literal(value: .boolean(true)) }
    if match(.nil) { return .literal(value: .nil) }

    if case .string = peek.type {
      if !isAtEnd { _ = advance() }
      if case let .string(value) = previous.type { return .literal(value: .string(value)) }
    }

    if case .identifier = peek.type {
      _ = advance()
      return .variable(name: previous)
    }

    if case .number = peek.type {
      if !isAtEnd { _ = advance() }
      if case let .number(value) = previous.type { return .literal(value: .number(value)) }
    }

    if match(.leftParen) {
      let expr = try expression()
      _ = try chomp(.rightParen, "Expect ')' after expression.")
      return .grouping(expression: expr)
    }

    throw ParserError.expected(message: "Expect expression", token: peek)
  }

  private func synchronize() {
    _ = advance()

    while !isAtEnd {
      guard previous.type != .semicolon else { return }

      switch peek.type {
      case .class, .fun, .var, .for, .if, .while, .print, .return:
        return
      default:
        _ = advance()
      }
    }
  }

  private func match(_ types: TokenType...) -> Bool {
    for type in types {
      if check(type) {
        _ = advance()
        return true
      }
    }
    return false
  }

  private func check(_ type: TokenType) -> Bool { isAtEnd ? false : peek.type == type }

  private func advance() -> Token {
    if !isAtEnd {
      current += 1
    }
    return previous
  }

  private func chomp(_ type: TokenType, _ message: String) throws(ParserError) -> Token {
    if check(type) {
      return advance()
    }
    throw ParserError.expected(message: message, token: peek)
  }

  private func chompIdentifier() throws -> Token {
    if case .identifier = peek.type {
      return advance()
    }
    throw ParserError.expected(message: "Expected a variable name.", token: peek)
  }

  private var isAtEnd: Bool { peek.type == .eof }
  private var peek: Token { tokens[current] }
  private var previous: Token { tokens[current - 1] }
}
