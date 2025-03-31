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
