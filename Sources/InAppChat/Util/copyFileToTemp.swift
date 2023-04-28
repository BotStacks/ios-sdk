
import Foundation

func tmpFile() throws -> URL {
  let dir = try FileManager.default.url(
    for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
  var tmp: URL!
  if #available(iOS 16.0, *) {
    tmp = dir.appending(path: UUID().uuidString)
  } else {
    // Fallback on earlier versions
    tmp = dir.appendingPathComponent(UUID().uuidString)
  }
  return tmp
}

func copyFileToTemp(url: URL) throws -> URL {
  let tmp = try tmpFile()
  try FileManager.default.copyItem(at: url, to: tmp)
  return tmp
}
