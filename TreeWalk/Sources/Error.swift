import ArgumentParser

enum LoxError: Error, CustomStringConvertible {
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

  var description: String {
    switch self {
    case .syntax(let line, let `where`, let message):
      return "[line \(line)] Error in \(`where`): \(message)"
    case .runtime(let line, let message):
      return "[line \(line)] Runtime Error: \(message)"
    case .fileError(let message):
      return "Error reading: \(message)"
    }
  }
}
