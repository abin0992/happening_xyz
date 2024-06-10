//
//  Logging.swift
//  ShoppingCart
//
//  Created by Abin Baby on 06/06/2024.
//

import Foundation

public func DLog(
    _ message: String,
    filename: String = #file,
    function: String = #function,
    line: Int = #line
) {
    #if DEBUG
        print("[\((filename as NSString).lastPathComponent):\(line) (\(function))] \(message)")
    #endif
}

// MARK: - NetworkErrorLogger

protocol NetworkErrorLogger {
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: ClientError)
    func log(
        request: URLRequest?,
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?
    )
}

// MARK: - DefaultNetworkErrorLogger

internal class DefaultNetworkErrorLogger: NetworkErrorLogger {
    public init() {}

    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else {
            return
        }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            DLog("responseData: \(String(describing: dataDict))")
        }
    }

    public func log(error: ClientError) {
        DLog("\(error.localizedDescription)")
    }
}

extension DefaultNetworkErrorLogger {
    func log(
        request: URLRequest? = nil,
        data: Data? = nil,
        response: HTTPURLResponse? = nil,
        error: Error? = nil
    ) {
        var message = ""
        if let request = request {
            message += "\n⬅️⬅️⬅️⬅️⬅️ Request:\n\(request.logMessage())"
        }

        message += "\n\n➡️➡️➡️➡️➡️ Response:\n"

        if let statusCode = response?.statusCode {
            message += "🔢 Status code: \(statusCode)\n"
        }

        if let headers = response?.allHeaderFields as? [String: AnyObject] {
            message += "👤 Headers: \(JSONSerialization.prettyPrintedString(from: headers))\n"
        }

        if let data = data {
            if let json = try? JSONSerialization.jsonObject(with: data) {
                message += "📦 Payload: \(JSONSerialization.prettyPrintedString(from: json))\n"
            } else {
                message += "📦 Payload: \(String(data: data, encoding: .utf8) ?? "")\n"
            }
        }

        if let error = error {
            message += "⛔️ Error: \(error.localizedDescription)\n"
        }

        // Use your logging mechanism here. For demonstration, print is used.
        DLog(message)
    }
}

private extension URLRequest {

    func logMessage() -> String {
        var result = ""
        result += "🎯 Endpoint: \(url!)\n"
        result += "👤 Headers: \(allHTTPHeaderFields!)\n"
        result += "⚙️ Method: \(httpMethod!)\n"

        if let httpBody = httpBody {
            let bodyDict = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]

            if let bodyDict = bodyDict {
                result += "📦 Body: \(bodyDict.prettyPrint())"
            } else if let resultString = String(data: httpBody, encoding: .utf8) {
                result += "📦 Body: \(resultString)"
            }
        }

        return result
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string = ""
        var options: JSONSerialization.WritingOptions
        if #available(iOS 13.0, macOS 11, *) {
            options = [.prettyPrinted, .withoutEscapingSlashes]
        } else {
            options = [.prettyPrinted]
        }
        if let data = try? JSONSerialization.data(withJSONObject: self, options: options) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

extension JSONSerialization {
    static func prettyPrintedString(from jsonObject: Any) -> String {
        var string = ""
        var options: JSONSerialization.WritingOptions
        if #available(iOS 13.0, macOS 11, *) {
            options = [.prettyPrinted, .withoutEscapingSlashes]
        } else {
            options = [.prettyPrinted]
        }
        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: options) {
            string = String(decoding: data, as: UTF8.self)
        }
        return string
    }
}
