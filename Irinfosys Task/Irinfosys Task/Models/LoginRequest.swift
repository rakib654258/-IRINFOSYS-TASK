//
//  LoginRequest.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
}
