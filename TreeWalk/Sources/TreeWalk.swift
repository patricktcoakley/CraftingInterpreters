import ArgumentParser

@main
struct TreeWalk: ParsableCommand {
  @Option(help: "The path to the file to run.")
  var path: String?

  func run() throws {
    let lox = Lox()

    if let path {
      do throws(LoxError) {
        return try lox.run(fileWithPath: path)
      } catch {
        print(error.localizedDescription)
        Self.exit(withError: error.exitCode)
      }
    }

    let repl = REPL(lox: lox)
    try repl.run()
  }
}
