//
//  XCTestCase+Places.swift
//  TripPlannerCoreTests
//
//  Created by Alexandr Vasildzhagaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension XCTestCase {

    static func anyPlace(

        _ name: String = "",
        coordinate: Coordinate = .zero

    ) -> Place {

        .init(name: name, coordinate: coordinate)
    }
}
