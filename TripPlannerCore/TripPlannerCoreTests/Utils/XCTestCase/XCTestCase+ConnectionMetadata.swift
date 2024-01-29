//
//  XCTestCase+ConnectionMetadata.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension XCTestCase {

    func anyMetadata(_ price: Int = 0, _ distance: Float = 0) -> ConnectionMetadata {

        .init(price: price, approxDistance: distance)
    }
}
