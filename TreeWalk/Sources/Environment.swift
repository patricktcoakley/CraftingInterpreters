public class Environment {
  var enclosing: Environment?
  private var values: [String: LoxValue] = [:]

  init(enclosing: Environment) {
    self.enclosing = enclosing
  }

  public func define(_ name: String, _ value: LoxValue) {
    values[name] = value
  }

  public func get(_ name: String) throws(RuntimeError) -> LoxValue {
    if let value = values[name] {
      return value
    }

    if let enclosing = enclosing {
      return try enclosing.get(name)
    }

    throw RuntimeError(Token(type: .identifier(name), line: 0), "Undefined variable '\(name)'.")
  }

  public func assign(_ name: String, _ value: LoxValue) throws(RuntimeError) -> LoxValue {
    if values.keys.contains(name) {
      values[name] = value
      return value
    }

    if let enclosing { return try enclosing.assign(name, value) }

    throw RuntimeError(Token(type: .identifier(name), line: 0), "Undefined variable '\(name)'.")
  }
}
