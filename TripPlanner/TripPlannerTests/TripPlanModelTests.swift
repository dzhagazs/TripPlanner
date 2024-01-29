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

        _ = makeSUT(planner)

        XCTAssertEqual(planner.calls, [])
    }

    func test_load_forwardsCallToPlanner() {

        let exp = expectation(description: "Wait for completion.")

        let sut = makeSUT(planner, exp: exp)
        sut.load()

        wait(for: [exp])

        XCTAssertTrue(planner.calls.first == .loadPlaces)
    }

    func test_load_updatesVmLoadingDuringLoading() {

        let exp = expectation(description: "Wait for completion.")

        let sut = makeSUT(planner, exp: exp)
        sut.load()

        XCTAssertEqual(sut.vm.loading, true)

        wait(for: [exp])

        XCTAssertEqual(sut.vm.loading, false)
    }

    func test_load_reflectsPlannerPlaces() {

        let places = [

            Self.anyPlace("a"),
            Self.anyPlace("b")
        ]
        planner.result.loadPlaces = .success(places)

        let exp = expectation(description: "Wait for completion.")

        let sut = makeSUT(planner, exp: exp)
        sut.load()

        wait(for: [exp])

        XCTAssertEqual(sut.vm.places, places.asAnnotations)
    }

    // MARK: Private

    private let planner = TripPlannerStub()

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

extension Array where Element == Place {

    var asAnnotations: [PlaceAnnotation] {

        self.map { .init(

            title: $0.name,
            coordinates: .init(

                latitude: Double($0.coordinate.latitude),
                longitude: Double($0.coordinate.longitude)))
        }
    }
}
