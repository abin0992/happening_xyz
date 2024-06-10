//
//  HTTPClient.swift
//  ShoppingCart
//
//  Created by Abin Baby on 06/06/2024.
//

import Combine
import Foundation

protocol HTTPClientProtocol {
    func performRequest(url: URL, method: HTTPMethod, body: Data?) -> AnyPublisher<Data, Error>
}

final class HTTPClient: HTTPClientProtocol {

    private let logger: NetworkErrorLogger = DefaultNetworkErrorLogger()

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func performRequest(
        url: URL,
        method: HTTPMethod = .get,
        body: Data? = nil
    ) -> AnyPublisher<Data, Error> {

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body

        return session.dataTaskPublisher(for: request)
           .tryMap { [weak self] result -> Data in
               guard let self = self else { throw URLError(.badServerResponse) }
               guard let httpResponse = result.response as? HTTPURLResponse else {
                   throw URLError(.cannotParseResponse)
               }

               #if DEBUG
               let logError: Error? = 200..<300 ~= httpResponse.statusCode ? nil : URLError(.badServerResponse)

               let prettyPrintedJSON = self.prettyPrintedJSON(from: result.data)
               self.logger.log(
                   request: request,
                   data: prettyPrintedJSON.data(using: .utf8),
                   response: httpResponse,
                   error: logError
               )
               #endif

               // Validate the response status code
               guard 200..<300 ~= httpResponse.statusCode else {
                   throw URLError(.badServerResponse)
               }

               return result.data
           }
           .catch { error -> AnyPublisher<Data, Error> in
               DLog(error.localizedDescription)
               return Fail(error: error).eraseToAnyPublisher()
           }
            .retry(3)
            .eraseToAnyPublisher()
    }

    private func prettyPrintedJSON(from data: Data) -> String {
        guard let object = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) else {
            return String(decoding: data, as: UTF8.self) // Return original data string if not JSON
        }
        return String(decoding: prettyData, as: UTF8.self)
    }
}

