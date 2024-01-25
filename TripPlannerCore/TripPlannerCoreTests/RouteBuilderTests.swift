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
    typealias Error = RouteBuilderError

    func test_build_returnsOriginalConnectionIfPointsAreConnected() {

        expectToBuild(

            [Route(path: ["a", "b"], weight: 1)],
            with: [("a", "b")]
        )
    }

    func test_build_returnsEmptyForEmptyInput() {

        expectToBuild([], with: [])
    }

    func test_build_failsIfToIsNotInGraph() {

        expectToFail(.toNotFound, with: [("a", "c")])
        expectToFail(.toNotFound, with: [("b", "c")])
        expectToFail(.toNotFound, with: [("b", "c"), ("a", "c"), ("d", "a")])
    }

    func test_build_failsIfFromIsNotInGraph() {

        expectToFail(.fromNotFound, with: [("c", "b")])
        expectToFail(.fromNotFound, with: [("d", "b")])
        expectToFail(.fromNotFound, with: [("b", "a"), ("c", "b"), ("d", "a")])
    }

    // MARK: Private

    private static func makeSUT() -> SUT { .init() }

    private func expectToBuild(

        _ routes: [Route<String, Int>],
        from: String = "a",
        to: String = "b",
        with connections: [(String, String)],
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let sut = Self.makeSUT()

            let result = try await sut.build(

                from: from,
                to: to,
                connections: connections,
                weightCalculator: { _ in 1 }
            )

            XCTAssertEqual(result, routes, file: file, line: line)
        }
    }

    private func expectToFail(

        _ error: Error,
        from: String = "a",
        to: String = "b",
        with connections: [(String, String)] = [], 
        file: StaticString = #file,
        line: UInt = #line

    ) {

            expectToThrow(error, file: file, line: line) {

                let sut = Self.makeSUT()

                let _ = try await sut.build(

                    from: from,
                    to: to,
                    connections: connections,
                    weightCalculator: { _ in 1 }
                )
            }
        }
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

enum RouteBuilderError: Swift.Error, Equatable {

    case toNotFound
    case fromNotFound
}
