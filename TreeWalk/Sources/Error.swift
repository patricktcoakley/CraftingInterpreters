import ArgumentParser

public enum LoxError: Error, CustomStringConvertible {
  case runtime(line: Int, message: String)
  case syntax(line: Int, where: String, message: String)
  case fileError(message: String)

  var exitCode: ExitCode {
    switch self {
    case .syntax: ExitCode(65)
    case .runtime: ExitCode(70)
    case .fileError: ExitCode(74)
    }
  }

  public var description: String {
    switch self {
    case let .syntax(line, `where`, message):
      return "[line \(line)] Error in \(`where`): \(message)"
    case let .runtime(line, message):
      return "[line \(line)] Runtime Error: \(message)"
    case let .fileError(message):
      return "Error reading: \(message)"
    }
  }
}

public enum ParserError: Error, CustomStringConvertible {
  case expected(message: String, token: Token)
  case invalid(token: Token)

  public var description: String {
    switch self {
    case let .expected(message, token):
      return "\(message) with \(token)"

    case let .invalid(token):
      return "Invalid token: \(token)"
    }
  }
}

// TODO: Refactor into enum
public struct RuntimeError: Error, CustomStringConvertible {
  let token: Token
  let message: String

  init(_ token: Token, _ message: String) {
    self.token = token
    self.message = message
  }

  public var description: String {
    "[line \(token.line)] Runtime Error: \(message)"
  }
}
