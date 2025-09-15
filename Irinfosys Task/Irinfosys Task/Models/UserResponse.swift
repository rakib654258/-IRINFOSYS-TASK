//
//  UserResponse.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import Foundation

struct UserResponse: Codable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [User]
}

struct User: Codable, Identifiable, Equatable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String?

    var fullName: String { "\(first_name) \(last_name)" }
}
