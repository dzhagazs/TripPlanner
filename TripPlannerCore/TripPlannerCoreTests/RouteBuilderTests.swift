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

    func test_build_findsShortestPathAmongThreePossiblePaths() {

        expectToBuildFirst(

            route: .init(path: ["a", "d", "c", "b"], weight: 6),
            with: [

                ("a", "d"),
                ("a", "c"),
                ("d", "b"),
                ("d", "c"),
                ("c", "b")
            ],
            calculator: { connection in

                switch connection {

                case ("a", "d"): return 2
                case ("a", "c"): return 6
                case ("d", "b"): return 6
                case ("d", "c"): return 3
                case ("c", "b"): return 1
                default:

                    XCTFail("Attempt to calculate unexisting connection \(connection.0) -> \(connection.1).")

                    return 0
                }
            }
        )
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

    private func makeSUT() -> SUT {

        let sut = SUT()

        trackMemoryLeak(for: sut)

        return sut
    }

    private func expectToBuildFirst(

        route: Route<String, Int>,
        from: String = "a",
        to: String = "b",
        with connections: [(String, String)],
        calculator: @escaping (((String, String)) async throws -> Int) = { _ in 1 },
        file: StaticString = #file,
        line: UInt = #line

    ) {

        expectToBuild(

            [route],
            from: from,
            to: to,
            with: connections,
            calculator: calculator,
            resultFilter: { ($0.first != nil) ? [$0.first!] : [] },
            file: file,
            line: line
        )
    }

    private func expectToBuild(

        _ routes: [Route<String, Int>],
        from: String = "a",
        to: String = "b",
        with connections: [(String, String)],
        calculator: @escaping (((String, String)) async throws -> Int) = { _ in 1 },
        resultFilter: @escaping ([Route<String, Int>]) -> [Route<String, Int>] = { $0 },
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let sut = self.makeSUT()

            let result = try await sut.build(

                from: from,
                to: to,
                connections: connections,
                weightCalculator: calculator
            )

            XCTAssertEqual(routes, resultFilter(result), file: file, line: line)
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

            let sut = self.makeSUT()

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
