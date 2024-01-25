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
        calculator: @escaping (((String, String)) async throws -> Int) = { _ in 1 },
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let sut = Self.makeSUT()

            let result = try await sut.build(

                from: from,
                to: to,
                connections: connections,
                weightCalculator: calculator
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

extension Route<String, Int>: CustomStringConvertible {

    public var description: String {

        "\n(\(path.map { "\($0)" }.joined(separator: " -> "))): \(weight)"
    }
}
