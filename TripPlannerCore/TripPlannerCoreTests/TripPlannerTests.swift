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
}
