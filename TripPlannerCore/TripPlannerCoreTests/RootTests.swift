//
//  RootTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class RootTests: XCTestCase {

    func test_start_returnsCorrectImplementation() {

        XCTAssertTrue(start() is TripPlannerImpl)
    }
}
