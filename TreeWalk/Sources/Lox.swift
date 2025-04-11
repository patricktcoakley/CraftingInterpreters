import Foundation

class Lox {
  var interpreter = Interpreter()

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
    let parser = Parser(tokens: tokens)
    do {
      let statments = try parser.parse()
      interpreter.interpret(statments)
    } catch {
      print(error.localizedDescription)
    }
  }
}
