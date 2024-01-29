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

        let sut = makeSUT(planner, exp: exp)
        sut.load()

        wait()

        XCTAssertTrue(planner.calls.first == .loadPlaces)
    }

    func test_load_updatesVmLoadingDuringLoading() {

        let sut = makeSUT(planner, exp: exp)
        sut.load()

        XCTAssertEqual(sut.vm.loading, true)

        wait()

        XCTAssertEqual(sut.vm.loading, false)
    }

    func test_load_reflectsPlannerPlaces() {

        let places = [

            Self.anyPlace("a"),
            Self.anyPlace("b")
        ]
        planner.result.loadPlaces = .success(places)

        let sut = makeSUT(planner, exp: exp)
        sut.load()

        wait()

        XCTAssertEqual(sut.vm.places, places.asAnnotations)
    }

    func test_load_refreshesPickers() {

        let sut = makeSUT(planner, exp: exp)

        planner.from = Self.anyPlace("a")
        planner.to = Self.anyPlace("b")

        sut.load()

        wait()

        XCTAssertEqual(sut.vm.fromValue.value, "a")
        XCTAssertEqual(sut.vm.toValue.value, "b")
    }

    func test_load_refreshesSuggestions() {

        let sut = makeSUT(planner, exp: exp)

        planner.result.fromSuggestions = [Self.anyPlace("a")]
        planner.result.toSuggestions = [Self.anyPlace("b")]

        sut.load()

        wait()

        XCTAssertEqual(planner.calls.filter { $0 == .fromSuggestions("") }.count, 1)
        XCTAssertEqual(planner.calls.filter { $0 == .toSuggestions("") }.count, 1)
        XCTAssertEqual(sut.fromPickerVM.suggestions, ["a"])
        XCTAssertEqual(sut.toPickerVM.suggestions, ["b"])
    }

    func test_selectFrom_updatesSelection() {
        let sut = makeSUT(planner, exp: exp)

        planner.result.loadPlaces = .success([Self.anyPlace("from")])
        sut.load()

        wait()

        sut.selectFrom("from")

        XCTAssertEqual(planner.calls.filter { $0 == .selectFrom("from") }.count, 1)
    }

    func test_selectTo_updatesSelection() {

        let sut = makeSUT(planner, exp: exp)

        planner.result.loadPlaces = .success([Self.anyPlace("to")])
        sut.load()

        wait()

        sut.selectTo("to")

        XCTAssertEqual(planner.calls.filter { $0 == .selectTo("to") }.count, 1)
    }

    // MARK: Private

    private let planner = TripPlannerStub()
    private lazy var exp: XCTestExpectation = { expectation(description: "Wait for completion.") }()

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

    private func wait() { wait(for: [exp], timeout: 1) }
}
