//
//  MockHTTPClient.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import Foundation
@testable import Irinfosys_Task

final class MockHTTPClient: HTTPClientProtocol {
    
    var nextData: Data?
    var nextResponseStatus: Int = 200
    var nextError: Error?

    func sendRequest<T>(_ request: URLRequest, as type: T.Type) async throws -> T where T : Decodable {
        if let err = nextError { throw err }
        guard let data = nextData else { throw HTTPError.invalidURL }
        if !(200..<300).contains(nextResponseStatus) {
            throw HTTPError.requestFailed(nextResponseStatus, data)
        }
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw HTTPError.decoding(error)
        }
    }

    func sendNoResponse(_ request: URLRequest) async throws {
        if let err = nextError { throw err }
        if !(200..<300).contains(nextResponseStatus) {
            throw HTTPError.requestFailed(nextResponseStatus, nil)
        }
    }
}
