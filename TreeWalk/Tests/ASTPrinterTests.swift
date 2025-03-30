import Testing
import TreeWalk

// A smoke test from the end of chapter 5
@Test func testPrint() {
  let printer = ASTPrinter()
  let expr = Expression.binary(
    left: .unary(operator: .init(type: .minus, line: 1), right: .literal(value: .number(123))),
    operator: .init(type: .star, line: 1),
    right: .grouping(expression: .literal(value: .number(45.67)))
  )

  let result = printer.print(expr)

  #expect(result == "(* (- 123) (group 45.67))")
}
