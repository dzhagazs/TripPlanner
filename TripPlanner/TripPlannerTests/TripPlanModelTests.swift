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

        _ = makeSUT()

        XCTAssertEqual(planner.calls, [])
    }

    func test_load_forwardsCallToPlanner() {

        let sut = makeSUT(exp: expectation())
        sut.load()

        wait()

        XCTAssertTrue(planner.calls.first == .loadPlaces)
    }

    func test_load_updatesVmLoadingDuringLoading() {

        let sut = makeSUT(exp: expectation())
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

        let sut = makeSUT(exp: expectation())
        sut.load()

        wait()

        XCTAssertEqual(sut.vm.places, places.asAnnotations)
    }

    func test_load_refreshesPickers() {

        let sut = makeSUT(exp: expectation())

        planner.from = Self.anyPlace("a")
        planner.to = Self.anyPlace("b")

        sut.load()

        wait()

        XCTAssertEqual(sut.vm.fromValue.value, "a")
        XCTAssertEqual(sut.vm.toValue.value, "b")
    }

    func test_load_refreshesSuggestions() {

        let sut = makeSUT(exp: expectation())

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

        let sut = makeSUT(exp: expectation())

        planner.result.loadPlaces = .success([Self.anyPlace("from")])
        sut.load()

        wait()

        sut.selectFrom("from")

        XCTAssertEqual(planner.calls.filter { $0 == .selectFrom("from") }.count, 1)
    }

    func test_selectTo_updatesSelection() {

        let sut = makeSUT(exp: expectation())

        planner.result.loadPlaces = .success([Self.anyPlace("to")])
        sut.load()

        wait()

        sut.selectTo("to")

        XCTAssertEqual(planner.calls.filter { $0 == .selectTo("to") }.count, 1)
    }

    func test_selectTo_buildsRouteIfFromSelected() {

        let sut = makeSUT(exp: expectation())

        planner.result.loadPlaces = .success([Self.anyPlace("to"), Self.anyPlace("from")])
        planner.from = Self.anyPlace("from")
        planner.to = Self.anyPlace("to")

        sut.load()

        XCTAssertEqual(asyncRunner.calls, 1)

        wait()
        expectation()

        sut.selectTo("to")

        wait()

        XCTAssertEqual(planner.calls.filter { $0 == .build }.count, 1)
        XCTAssertEqual(asyncRunner.calls, 2)
    }

    func test_selectFrom_buildsRouteIfToSelected() {

        let sut = makeSUT(exp: expectation())

        planner.result.loadPlaces = .success([Self.anyPlace("to"), Self.anyPlace("from")])
        planner.from = Self.anyPlace("from")
        planner.to = Self.anyPlace("to")

        sut.load()

        XCTAssertEqual(asyncRunner.calls, 1)

        wait()
        expectation()

        sut.selectFrom("from")

        wait()

        XCTAssertEqual(planner.calls.filter { $0 == .build }.count, 1)
        XCTAssertEqual(asyncRunner.calls, 2)
    }

    func test_selectTo_doesNotBuildRouteIfFromIsNotSelected() {

        let sut = makeSUT(exp: expectation())

        planner.result.loadPlaces = .success([Self.anyPlace("to"), Self.anyPlace("from")])
        planner.to = Self.anyPlace("to")

        sut.load()

        wait()

        sut.selectTo("to")

        XCTAssertEqual(planner.calls.filter { $0 == .build }.count, 0)
        XCTAssertEqual(asyncRunner.calls, 1)
    }

    func test_selectFrom_doesNotBuildRouteIfToIsNotSelected() {

        let sut = makeSUT(exp: expectation())

        planner.result.loadPlaces = .success([Self.anyPlace("to"), Self.anyPlace("from")])
        planner.from = Self.anyPlace("from")

        sut.load()

        wait()

        sut.selectFrom("from")

        XCTAssertEqual(planner.calls.filter { $0 == .build }.count, 0)
        XCTAssertEqual(asyncRunner.calls, 1)
    }

    // MARK: Private

    private let planner = TripPlannerStub()
    private let asyncRunner = AsyncRunnerStub()
    private var exp: XCTestExpectation!

    func makeSUT(exp: XCTestExpectation? = nil) -> SUT {

        let syncRunner = SyncRunnerStub()
        let sut = SUT.init(

            planner: planner,
            asyncRunner: asyncRunner,
            callbackRunner: syncRunner
        )

        trackMemoryLeak(for: sut)
        trackMemoryLeak(for: syncRunner)

        return sut
    }

    private func wait() { wait(for: [exp], timeout: 1) }

    @discardableResult private func expectation() -> XCTestExpectation {

        exp = expectation(description: "Wait for completion.")

        asyncRunner.expectation = exp

        return exp
    }
}
