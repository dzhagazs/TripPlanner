//
//  ConnectionLoaderFactoryTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class ConnectionLoaderFactoryTests: XCTestCase {

    typealias SUT = ConnectionLoaderFactory

    func test_create_returnsCorrectImplementation() {

        XCTAssertTrue(SUT.create() is ConnectionLoaderImpl)
    }
}
