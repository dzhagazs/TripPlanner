//
//  DistanceCalculatorTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class DistanceCalculatorTests: XCTestCase {

    typealias SUT = DistanceCalculator

    func test_distance_isCalculatedCorrectly() {

        let london = Coordinate(latitude: 51.5285582, longitude: -0.241681)
        let tokyo = Coordinate(latitude: 35.652832, longitude: 139.839478)
        let porto = Coordinate(latitude: 41.14961, longitude: -8.61099)

        let distances = [

            (london, tokyo, Float(9593537.0)),
            (london, porto, Float(1319441.0)),
            (tokyo, porto, Float(10912841.0))
        ]

        distances.forEach { connection in

            XCTAssertEqual(connection.2, SUT.distance(from: connection.0, to: connection.1))
        }
    }
}
