//
//  ConnectionDecoderFactoryTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 30.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class ConnectionDecoderFactoryTests: XCTestCase {

    typealias SUT = ConnectionDecoderFactory

    func test_create_returnsCorrectImplementation() {

        XCTAssertTrue(SUT.create() is ConnectionDecoderImpl)
    }
}
