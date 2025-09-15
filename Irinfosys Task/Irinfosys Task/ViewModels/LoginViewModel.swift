//
//  LoginViewModel.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func loginDidStart()
    func loginDidSucceed()
    func loginDidFail(error: String)
}

final class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    private let api: APIServiceProtocol

    var email: String = ""
    var password: String = ""
    var errorMessage: String?
    var isLoggedIn: Bool = false

    init(api: APIServiceProtocol) {
        self.api = api
    }
    func login() async {
        delegate?.loginDidStart()
        do {
            _ = try await api.loginRequest(email: email, password: password)
            self.isLoggedIn = true
            delegate?.loginDidSucceed()
        } catch {
            self.errorMessage = error.localizedDescription
            delegate?.loginDidFail(error: error.localizedDescription)
        }
    }
}
