import ArgumentParser

@main
struct Interpreter: ParsableCommand {
  @Option(help: "The path to the file to run.")
  var path: String?

  func run() throws {
    let lox = Lox()

    if let path {
      do throws(LoxError) {
        return try lox.run(fileWithPath: path)
      } catch {
        print(error)
        Self.exit(withError: error.exitCode)
      }
    }

    let repl = REPL(lox: lox)
    try repl.run()
  }
}
