public class Tokenizer {
  let source: String

  private var tokens: [Token] = []
  private var startIndex: String.Index
  private var currentIndex: String.Index
  private var line = 1

  public init(_ source: String) {
    self.source = source
    self.startIndex = source.startIndex
    self.currentIndex = source.startIndex
  }

  public func tokenize() throws(LoxError) -> [Token] {
    while !isAtEnd {
      startIndex = currentIndex
      try scan()
    }

    addToken(.eof)
    return tokens
  }

  private var isAtEnd: Bool { currentIndex >= source.endIndex }
  private var peek: Character { isAtEnd ? "\0" : source[currentIndex] }

  private var peekNext: Character {
    let nextIndex = source.index(after: currentIndex)
    return nextIndex >= source.endIndex ? "\0" : source[nextIndex]
  }

  private func scan() throws(LoxError) {
    let char = advance()
    guard !char.isWhitespace else { return }

    switch char {
    // Single-character cases
    case "(": addToken(.leftParen)
    case ")": addToken(.rightParen)
    case "{": addToken(.leftBrace)
    case "}": addToken(.rightBrace)
    case ",": addToken(.comma)
    case ".": addToken(.dot)
    case "-": addToken(.minus)
    case "+": addToken(.plus)
    case ";": addToken(.semicolon)
    case "*": addToken(.star)
    case "\n": line += 1
    case "\"": try handleString()
    // Possible two-character cases
    case "!", "=", "<", ">", "/":
      switch (char, peek) {
      case ("!", "="): _ = advance(); addToken(.bangEqual)
      case ("=", "="): _ = advance(); addToken(.equalEqual)
      case ("<", "="): _ = advance(); addToken(.lessEqual)
      case (">", "="): _ = advance(); addToken(.greaterEqual)
      // Single-line comment
      case ("/", "/"):
        while peek != "\n", !isAtEnd {
          _ = advance()
        }
      case ("!", _): addToken(.bang)
      case ("=", _): addToken(.equal)
      case ("<", _): addToken(.less)
      case (">", _): addToken(.greater)
      case ("/", _): addToken(.slash)
      default:
        throw LoxError.syntax(line: line, where: "scan", message: "Unexpected character combination \(char)\(peek).")
      }
    // Literals
    default:
      if char.isNumber {
        try handleNumber()
      } else if char.isLetter || char == "_" {
        try handleKeywordOrIdentifier()
      } else {
        throw LoxError.syntax(line: line, where: "scan", message: "Unexpected character \(char).")
      }
    }
  }

  private func advance() -> Character {
    let char = source[currentIndex]
    currentIndex = source.index(after: currentIndex)
    return char
  }

  private func addToken(_ type: TokenType) {
    tokens.append(Token(type: type, line: line))
  }

  private func handleString() throws(LoxError) {
    while peek != "\"", !isAtEnd {
      if peek == "\n" {
        line += 1
      }

      _ = advance()
    }

    if isAtEnd {
      throw LoxError.syntax(line: line, where: "handleString", message: "Unterminated string.")
    }

    _ = advance() // Closing `"`

    let stringStartIndex = source.index(after: startIndex)
    let value = String(source[stringStartIndex ..< source.index(before: currentIndex)])
    addToken(.literal(.string(value)))
  }

  private func handleNumber() throws(LoxError) {
    while peek.isNumber {
      _ = advance()
    }

    if peek == ".", peekNext.isNumber { // We hit the decimal place
      _ = advance() // Consume "."
      while peek.isNumber {
        _ = advance()
      }
    }

    guard let num = Double(source[startIndex ..< currentIndex]) else {
      throw LoxError.syntax(line: line, where: "number", message: "Invalid number.")
    }

    addToken(.literal(.number(num)))
  }

  private func handleKeywordOrIdentifier() throws(LoxError) {
    while peek.isLetter || peek.isNumber || peek == "_" {
      _ = advance()
    }

    let text = String(source[startIndex ..< currentIndex])

    // Have a hard limit on identifier length; C# uses 512 so let's use that
    guard text.count <= 512 else {
      throw LoxError.syntax(line: line, where: "identifier", message: "Identifier \(text) is length \(text.count), max is 512.")
    }

    // Fallback to identifier if keyword doesn't exist
    let type = handleKeyword(text) ?? .literal(.identifier(text))

    addToken(type)
  }

  private func handleKeyword(_ keyword: String) -> TokenType? {
    return switch keyword {
    case "and": .and
    case "class": .class
    case "else": .else
    case "false": .false
    case "for": .for
    case "fun": .fun
    case "if": .if
    case "nil": .literal(.nil)
    case "or": .or
    case "print": .print
    case "return": .return
    case "super": .super
    case "this": .this
    case "true": .true
    case "var": .var
    case "while": .while
    default: nil
    }
  }
}
