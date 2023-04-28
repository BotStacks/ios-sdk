import Foundation

func mentionsArray(_ text: String) -> [String] {
  let whole = NSRange(
    text.startIndex..<text.endIndex,
    in: text
  )
  let matches = mentionRegex.matches(in: text, range: whole)
  let _text = NSString(string: text)
  return matches.map { _text.substring(with: $0.range) }
}
