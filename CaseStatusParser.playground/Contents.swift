import UIKit

var greeting = "Hello, playground"

if let url = Bundle.main.url(forResource: "statusTitles", withExtension: "txt"),
   let contents = try? String(contentsOf: url, encoding: .utf8) {

    print("enum Status: String { ")
    contents
        .components(separatedBy: .newlines)
        .filter { $0 != "" }
        .forEach {
            let enumValue = $0
                .replacingOccurrences(of: "&#39;", with: "'")
            var enumName = $0
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "'", with: "")
                .replacingOccurrences(of: "/", with: "")
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: "&#39;", with: "")
            let firstChar = enumName.first!.lowercased()
            enumName = "\(firstChar)\(enumName.dropFirst())"
            print("    case \(enumName) = \"\(enumValue.trimmingCharacters(in: .whitespaces))\"")
        }
    print("}")
} else {
    print("Nope")
}
