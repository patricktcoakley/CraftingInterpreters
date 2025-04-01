import Testing
import TreeWalk

@Test func testHandleIdentifier() throws {
  let source = """
  andy formless fo _ab_cd ab123
  abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_

  """

  let expectedTokens: [Token] = [
    Token(type: .literal(.identifier("andy")), line: 1),
    Token(type: .literal(.identifier("formless")), line: 1),
    Token(type: .literal(.identifier("fo")), line: 1),
    Token(type: .literal(.identifier("_ab_cd")), line: 1),
    Token(type: .literal(.identifier("ab123")), line: 1),
    Token(type: .literal(.identifier("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_")), line: 2),
    Token(type: .eof, line: 3),
  ]

  let tokenizer = Tokenizer(source)
  let tokens = try tokenizer.tokenize()

  #expect(expectedTokens == tokens)
}

@Test func testHandleNumber() throws {
  let source = """
  123
  123.456
  .456
  123.

  """

  let expectedTokens: [Token] = [
    Token(type: .literal(.number(123.0)), line: 1),
    Token(type: .literal(.number(123.456)), line: 2),
    Token(type: .dot, line: 3),
    Token(type: .literal(.number(456.0)), line: 3),
    Token(type: .literal(.number(123.0)), line: 4),
    Token(type: .dot, line: 4),
    Token(type: .eof, line: 5),
  ]

  let tokenizer = Tokenizer(source)
  let tokens = try tokenizer.tokenize()

  #expect(expectedTokens == tokens)
}

@Test func testHandleString() throws {
  let source = """
  ""
  "string"

  """

  let expectedTokens: [Token] = [
    Token(type: .literal(.string("")), line: 1),
    Token(type: .literal(.string("string")), line: 2),
    Token(type: .eof, line: 3),
  ]

  let tokenizer = Tokenizer(source)
  let tokens = try tokenizer.tokenize()

  #expect(expectedTokens == tokens)
}

@Test func testHandleKeywords() throws {
  let source = """
  and class else false for fun if nil or return super this true var while

  """

  let expectedTokens: [Token] = [
    Token(type: .and, line: 1),
    Token(type: .class, line: 1),
    Token(type: .else, line: 1),
    Token(type: .false, line: 1),
    Token(type: .for, line: 1),
    Token(type: .fun, line: 1),
    Token(type: .if, line: 1),
    Token(type: .literal(.nil), line: 1),
    Token(type: .or, line: 1),
    Token(type: .return, line: 1),
    Token(type: .super, line: 1),
    Token(type: .this, line: 1),
    Token(type: .true, line: 1),
    Token(type: .var, line: 1),
    Token(type: .while, line: 1),
    Token(type: .eof, line: 2),
  ]

  let tokenizer = Tokenizer(source)
  let tokens = try tokenizer.tokenize()

  #expect(expectedTokens == tokens)
}

@Test func testHandlePunctuators() throws {
  let source = """
  (){};,+-*!===<=>=!=<>/.

  """

  let expectedTokens: [Token] = [
    Token(type: .leftParen, line: 1),
    Token(type: .rightParen, line: 1),
    Token(type: .leftBrace, line: 1),
    Token(type: .rightBrace, line: 1),
    Token(type: .semicolon, line: 1),
    Token(type: .comma, line: 1),
    Token(type: .plus, line: 1),
    Token(type: .minus, line: 1),
    Token(type: .star, line: 1),
    Token(type: .bangEqual, line: 1),
    Token(type: .equalEqual, line: 1),
    Token(type: .lessEqual, line: 1),
    Token(type: .greaterEqual, line: 1),
    Token(type: .bangEqual, line: 1),
    Token(type: .less, line: 1),
    Token(type: .greater, line: 1),
    Token(type: .slash, line: 1),
    Token(type: .dot, line: 1),
    Token(type: .eof, line: 2),
  ]

  let tokenizer = Tokenizer(source)
  let tokens = try tokenizer.tokenize()

  #expect(expectedTokens == tokens)
}

@Test func testWhitespace() throws {
  let source = """
  space    tabs        newlines




  end

  """

  let expectedTokens: [Token] = [
    Token(type: .literal(.identifier("space")), line: 1),
    Token(type: .literal(.identifier("tabs")), line: 1),
    Token(type: .literal(.identifier("newlines")), line: 1),
    Token(type: .literal(.identifier("end")), line: 6),
    Token(type: .eof, line: 7),
  ]

  let tokenizer = Tokenizer(source)
  let tokens = try tokenizer.tokenize()

  #expect(expectedTokens == tokens)
}
