//
//  RouteBuilderTests.swift
//  TripPlannerCoreTests
//
//  Created by Olexandr Vasildzhagaz on 25.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class RouteBuilderTests: XCTestCase {

    typealias SUT = DijkstrasRouteBuilder<Int, String>

    func test_build_returnsOriginalConnectionIfPointsAreConnected() {

        execute {

            let sut = Self.makeSUT()

            let route = try await sut.build(

                from: "a",
                to: "b",
                connections: [("a", "b")],
                weightCalculator: { _ in 1 }
            )

            XCTAssertEqual(route, .init(path: ["a", "b"], weight: 1))
        }
    }

    // MARK: Private

    private static func makeSUT() -> SUT { .init() }
}

extension Int: Number {

    public static var upperBound: Self { .max }
    public static var zero: Self { 0 }
}

extension Route<String, Int>: Equatable {

    public static func == (lhs: Route, rhs: Route) -> Bool {

        lhs.path == rhs.path && lhs.weight == rhs.weight
    }
}

final class DijkstrasRouteBuilder<W: Number, E: Hashable>: RouteBuilder {

    typealias Weight = W
    typealias RouteElement = E

    func build(

        from: E,
        to: E,
        connections: [(E, E)],
        weightCalculator: ((E, E)) async throws -> W

    ) async throws -> Route<E, W> {

        .init(path: [], weight: W.zero)
    }
}
