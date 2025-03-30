import Foundation

class Lox {
  static func report(line: Int, where: String, message: String) throws {
    throw LoxError.syntax(line: line, where: `where`, message: message)
  }

  func run(fileWithPath path: String) throws(LoxError) {
    let url = URL(fileURLWithPath: path)
    do {
      let input = try String(contentsOf: url)
      try run(input)
    } catch {
      throw LoxError.fileError(message: error.localizedDescription)
    }
  }

  func run(_ input: String) throws(LoxError) {
    let tokenizer = Tokenizer(input)
    let tokens = try tokenizer.tokenize()
    for token in tokens {
      print("\(token.description)")
    }
  }
}
