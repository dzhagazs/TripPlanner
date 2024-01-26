//
//  TripPlannerTests.swift
//  TripPlannerCoreTests
//
//  Created by Alexandr Vasildzhagaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class TripPlannerTests: XCTestCase {

    typealias SUT = TripPlanner

    // MARK: Private

    private static func makeSUT() -> SUT {

        TripPlannerImpl()
    }

    private func anyPlace(

        name: String = "",
        coordinate: Coordinate = .zero

    ) -> Place {

        .init(name: name, coordinate: coordinate)
    }

    private func anyCoordinate(lat: Float = 0, lon: Float = 0) -> Coordinate {

        .init(latitude: lat, longitude: lon)
    }
}

extension Coordinate {

     static let zero = Coordinate(latitude: 0, longitude: 0)
}
