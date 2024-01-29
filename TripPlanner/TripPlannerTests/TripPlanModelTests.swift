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

    func test_init_hasNoSideEffects() {

        let planner = TripPlannerStub()

        _ = makeSUT(planner)

        XCTAssertEqual(planner.calls, [])
    }

    // MARK: Private

    func makeSUT(

        _ planner: TripPlanner = TripPlannerStub(),
        exp: XCTestExpectation? = nil

    ) -> SUT {

        let asyncRunner = AsyncRunnerStub()
        let syncRunner = SyncRunnerStub()
        let sut = SUT.init(

            planner: planner,
            asyncRunner: asyncRunner,
            callbackRunner: syncRunner
        )

        trackMemoryLeak(for: sut)
        trackMemoryLeak(for: asyncRunner)
        trackMemoryLeak(for: syncRunner)

        asyncRunner.expectation = exp

        return sut

    }
}
