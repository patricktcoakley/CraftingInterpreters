class REPL {
  let lox: Lox

  init(lox: Lox) {
    self.lox = lox
  }

  func run() throws {
    while true {
      print("> ", terminator: "")
      if let line = readLine() {
        do throws(LoxError) {
          try lox.run(line)
        } catch {
          print(error)
        }
      }
    }
  }
}
