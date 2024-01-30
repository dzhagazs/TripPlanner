//
//  ConnectionDataSourceFactoryTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 30.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class ConnectionDataSourceFactoryTests: XCTestCase {

    typealias SUT = ConnectionDataSourceFactory

    func test_create_returnsCorrectImplementation() {

        XCTAssertTrue(SUT.create() is URLSession)
        XCTAssertEqual(SUT.create() as! URLSession, URLSession.shared)
    }
}
