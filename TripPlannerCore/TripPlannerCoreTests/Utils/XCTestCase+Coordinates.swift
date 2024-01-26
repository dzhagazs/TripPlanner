//
//  XCTestCase+Coordinates.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension XCTestCase {

    static func anyCoordinate(lat: Float = 0, lon: Float = 0) -> Coordinate {

        .init(latitude: lat, longitude: lon)
    }
}
