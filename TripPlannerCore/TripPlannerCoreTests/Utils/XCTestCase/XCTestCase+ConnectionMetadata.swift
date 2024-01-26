//
//  XCTestCase+ConnectionMetadata.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension XCTestCase {

    func anyMetadata(_ price: Int, _ distance: Float) -> ConnectionMetadata {

        .init(price: price, approxDistance: distance)
    }
}
