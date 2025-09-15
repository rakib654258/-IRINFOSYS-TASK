//
//  UsersViewModel.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import Foundation

protocol UsersViewModelDelegate: AnyObject {
    func usersFetchDidStart()
    func usersFetchDidSucceed(users: [User])
    func usersFetchDidFail(error: String)
}

final class UsersViewModel {
    weak var delegate: UsersViewModelDelegate?
    private let api: APIServiceProtocol
    private(set) var users: [User] = []

    init(api: APIServiceProtocol) {
        self.api = api
    }

    func fetchUsers() {
        delegate?.usersFetchDidStart()
        Task {
            do {
                let result = try await api.fetchUsers(page: 1)
                DispatchQueue.main.async {
                    self.users = result
                    self.delegate?.usersFetchDidSucceed(users: result)
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.usersFetchDidFail(error: error.localizedDescription)
                }
            }
        }
    }
}
