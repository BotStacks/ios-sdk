import Foundation

func mentionsToMarkdown(_ text: String) -> String {

  var result: String = ""
  let whole = NSRange(
    text.startIndex..<text.endIndex,
    in: text
  )

  let matches = mentionRegex.matches(in: text, range: whole)
  var _text = NSString(string: text)

  for match in matches {
    result += _text.substring(to: match.range.lowerBound)
    let matchText = _text.substring(with: match.range)
    result += "[\(matchText)](\(Bundle.main.bundleIdentifier!)://user/\(matchText))"
    _text = NSString(string:_text.substring(from: match.range.upperBound))
  }
  result += _text as String
  return result
}
