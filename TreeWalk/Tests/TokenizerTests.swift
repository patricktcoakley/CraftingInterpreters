import Testing
import TreeWalk

@Test func testHandleIdentifier() throws {
  let source = """
  andy formless fo _ab_cd ab123
  abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_
  """

  let expectedIdentifiers = [
    "andy",
    "formless",
    "fo",
    "_ab_cd",
    "ab123",
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_",
  ]

  let tokenizer = Tokenizer(source)
  let tokens = try tokenizer.tokenize()

  // Grab the identifier tokens
  let identifierTokens = tokens.compactMap { token -> String? in
    if case let .literal(.identifier(name)) = token.type {
      return name
    }
    return nil
  }

  #expect(identifierTokens == expectedIdentifiers)
}
