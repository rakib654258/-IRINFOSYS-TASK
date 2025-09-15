//
//  KeychainTokenStore.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import Foundation
import Security

final class KeychainTokenStore: TokenStoreProtocol {
    private let service = Bundle.main.bundleIdentifier ?? "com.Irinfosys-Task.app"
    private let account = "api_token"

    func save(token: String) throws {
        try clear()
        let data = token.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess { throw NSError(domain: "KeychainError", code: Int(status), userInfo: nil) }
    }

    func get() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess, let data = item as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: nil)
        }
    }

    func clear() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
