//
//  TokenStore.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//

import Foundation

protocol TokenStoreProtocol {
    func save(token: String) throws
    func get() throws -> String?
    func clear() throws
}

// In-memory store useful for tests
final class InMemoryTokenStore: TokenStoreProtocol {
    private var token: String?
    func save(token: String) throws { self.token = token }
    func get() throws -> String? { return token }
    func clear() throws { token = nil }
}
