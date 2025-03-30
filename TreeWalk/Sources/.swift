extension String {
  func from(start: Int, end: Int) -> String {
    let startIndex = self.index(self.startIndex, offsetBy: start)
    let endIndex = self.index(self.startIndex, offsetBy: end)
    return String(self[startIndex ..< endIndex])
  }

  func character(at index: Int) -> Character {
    return self[self.index(self.startIndex, offsetBy: index)]
  }
}
