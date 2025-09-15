//
//  LoginViewModelTests.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import XCTest
@testable import Irinfosys_Task

final class LoginViewModelTests: XCTestCase {
    func testLoginViewModelSuccessSetsLoggedIn() async {
        let mock = MockHTTPClient()
        let token = LoginResponse(token: "QpwL5tke4Pnpja7X4")
        mock.nextData = try? JSONEncoder().encode(token)
        let tokenStore = InMemoryTokenStore()
        let service = APIService(httpClient: mock, tokenStore: tokenStore)
        let vm = LoginViewModel(api: service)

        vm.email = "eve.holt@reqres.in"
        vm.password = "cityslicka"
        await vm.login()
        
        XCTAssertTrue(vm.isLoggedIn)
        XCTAssertNil(vm.errorMessage)
        XCTAssertEqual(try? tokenStore.get(), "QpwL5tke4Pnpja7X4")
    }

    func testLoginViewModelFailureShowsError() async {
        let mock = MockHTTPClient()
        mock.nextError = HTTPError.requestFailed(400, nil)
        let service = APIService(httpClient: mock, tokenStore: InMemoryTokenStore())
        let vm = LoginViewModel(api: service)

        vm.email = "email@example.com"
        vm.password = "pass"
        await vm.login()

        XCTAssertFalse(vm.isLoggedIn)
        XCTAssertNotNil(vm.errorMessage)
    }
}
