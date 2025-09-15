//
//  UserAPIService.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//

import Foundation

protocol APIServiceProtocol {
    func loginRequest(email: String, password: String) async throws -> String
    func fetchUsers(page: Int) async throws -> [User]
}

final class APIService: APIServiceProtocol {
    private let baseURL = URL(string: "https://reqres.in/api")!
    private let httpClient: HTTPClientProtocol
    private let tokenStore: TokenStoreProtocol?

    init(httpClient: HTTPClientProtocol = HTTPClient(), tokenStore: TokenStoreProtocol? = nil) {
        self.httpClient = httpClient
        self.tokenStore = tokenStore
    }

    func loginRequest(email: String, password: String) async throws -> String {
        let url = baseURL.appendingPathComponent("login")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        debugPrint("Request URL:", req.url?.absoluteString ?? "")
        debugPrint("Request Body:", String(data: req.httpBody ?? Data(), encoding: .utf8) ?? "")
        debugPrint("Email:", email)
        debugPrint("Password:", password)
        let body: [String: String] = ["email": email, "password": password]
        req.httpBody = try JSONEncoder().encode(body)
        debugPrint("Http Body value - \(req.httpBody != nil ? "Not Nil" : "Nil")")
        debugPrint("Request Body:", String(data: req.httpBody ?? Data(), encoding: .utf8) ?? "")
        let response: LoginResponse = try await httpClient.sendRequest(req, as: LoginResponse.self)
        // store token if tokenStore provided
        try tokenStore?.save(token: response.token)
        return response.token
    }
    
    func fetchUsers(page: Int = 1) async throws -> [User] {
        let url = baseURL.appendingPathComponent("users")
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comps.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        guard let finalURL = comps.url else { throw URLError(.badURL) }
        debugPrint("Final URL: \(finalURL)")
        var req = URLRequest(url: finalURL)
        req.httpMethod = "GET"
        req.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        // if token required for auth in future:
        if let token = try? tokenStore?.get() {
            debugPrint("Bearer \(token)")
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let response: UserResponse = try await httpClient.sendRequest(req, as: UserResponse.self)
        return response.data
    }
    
}
