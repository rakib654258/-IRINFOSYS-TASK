//
//  HTTPClient.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//

import Foundation

enum HTTPError: Error {
    case invalidURL
    case requestFailed(Int, Data?)
    case transport(Error)
    case decoding(Error)
}

extension HTTPError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let status, let data):
            if let data = data,
               let body = String(data: data, encoding: .utf8), !body.isEmpty {
                return "Request failed with status \(status): \(body)"
            }
            return "Request failed with status code \(status)"
        case .transport(let err):
            return "Transport error: \(err.localizedDescription)"
        case .decoding(let err):
            return "Decoding error: \(err.localizedDescription)"
        }
    }
}

// Protocol for DI & testing
protocol HTTPClientProtocol {
    func sendRequest<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T
    func sendNoResponse(_ request: URLRequest) async throws
}

final class HTTPClient: HTTPClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func sendRequest<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw HTTPError.invalidURL
            }
            guard 200..<300 ~= http.statusCode else {
                throw HTTPError.requestFailed(http.statusCode, data)
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw HTTPError.decoding(error)
            }
        } catch {
            throw HTTPError.transport(error)
        }
    }

    func sendNoResponse(_ request: URLRequest) async throws {
        do {
            let (_, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw HTTPError.invalidURL
            }
        } catch {
            throw HTTPError.transport(error)
        }
    }
}
