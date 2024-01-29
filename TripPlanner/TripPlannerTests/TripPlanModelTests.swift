//
//  TripPlanModelTests.swift
//  TripPlannerTests
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

@testable import TripPlanner

import TripPlannerCore
import XCTest

final class TripPlanModelTests: XCTestCase {

    typealias SUT = TripPlanModel

    func test_some() {

        
    }

    // MARK: Private

    func makeSUT() -> SUT {

        let sut = SUT.init(planner: TripPlannerStub())

        trackMemoryLeak(for: sut)

        return sut

    }
}
