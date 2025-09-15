//
//  APIServiceTests.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import XCTest
@testable import Irinfosys_Task

final class APIServiceTests: XCTestCase {
    func testLoginStoresTokenAndReturns() async throws {
        let mock = MockHTTPClient()
        let expectedToken = "QpwL5tke4Pnpja7X4"
        let loginResp = LoginResponse(token: expectedToken)
        mock.nextData = try JSONEncoder().encode(loginResp)
        let tokenStore = InMemoryTokenStore()
        let service = APIService(httpClient: mock, tokenStore: tokenStore)

        let token = try await service.loginRequest(email: "eve.holt@reqres.in", password: "cityslicka")

        XCTAssertEqual(token, expectedToken)
        XCTAssertEqual(try tokenStore.get(), expectedToken)
    }

    func testFetchUsersParsesList() async throws {
        let mock = MockHTTPClient()
        let user = User(id: 1, email: "test@test.com", first_name: "John", last_name: "Doe", avatar: "https://example.com/1.png")
        let resp = UserResponse(page: 1, per_page: 6, total: 6, total_pages: 1, data: [user])
        mock.nextData = try JSONEncoder().encode(resp)
        let service = APIService(httpClient: mock, tokenStore: nil)

        let users = try await service.fetchUsers(page: 1)
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first, user)
    }
}
