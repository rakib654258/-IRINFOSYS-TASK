//
//  TokenStoreTests.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import XCTest
@testable import Irinfosys_Task

final class TokenStoreTests: XCTestCase {
    func testInMemoryTokenStoreSaveGetClear() throws {
        let store = InMemoryTokenStore()
        try store.save(token: "abc")
        XCTAssertEqual(try store.get(), "abc")
        try store.clear()
        XCTAssertNil(try store.get())
    }
}
