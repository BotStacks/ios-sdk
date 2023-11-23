import Foundation

let linkPhoneTypes: NSTextCheckingResult.CheckingType = [.phoneNumber, .address]
let linkPhoneDetector = try! NSDataDetector(
  types: linkPhoneTypes.rawValue)
let characterSetSkipMD: [Character] = ["{", "(", "[", ":"]

func linkPhoneToMarkdown(_ text: String) -> String {
  var result = ""
  var _text = text
  let whole = NSRange(
    text.startIndex..<text.endIndex,
    in: text
  )
  linkPhoneDetector.enumerateMatches(
    in: text,
    range: whole
  ) {
    match, flags, bool in
    guard let match = match else {
      return
    }
    let firstChar = _text[_text.index(_text.startIndex, offsetBy: match.range.lowerBound)]
    if characterSetSkipMD.contains(firstChar) {
      return
    }
    result += _text[_text.startIndex..<_text.index(_text.startIndex, offsetBy: match.range.lowerBound)]
    switch match.resultType {
    case .phoneNumber:
      let phone = match.phoneNumber!
      result += "[\(phone)](tel:\(phone))"
    case .link:
      let link = match.url!.absoluteString
      result += "[\(link)](\(link))"
    default:
      break
    }
    _text = String(_text[text.index(text.startIndex, offsetBy: match.range.upperBound)...])
  }
  return result + _text
}
