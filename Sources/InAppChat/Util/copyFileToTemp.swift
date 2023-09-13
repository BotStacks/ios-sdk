
import Foundation

func tmpFile(ext: String? = nil) throws -> URL {
  let dir = try FileManager.default.url(
    for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
  var tmp: URL!
  let fileName = UUID().uuidString + (ext != nil ? ".\(ext!)" : "")
  if #available(iOS 16.0, *) {
    tmp = dir.appending(path: fileName)
  } else {
    // Fallback on earlier versions
    tmp = dir.appendingPathComponent(fileName)
  }
  return tmp
}

func copyFileToTemp(url: URL) throws -> URL {
  let tmp = try tmpFile()
  try FileManager.default.copyItem(at: url, to: tmp)
  return tmp
}
