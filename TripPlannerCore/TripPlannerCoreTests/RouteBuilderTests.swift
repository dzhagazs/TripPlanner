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
            weights: [

                (("a", "d"), 2),
                (("a", "c"), 6),
                (("d", "b"), 6),
                (("d", "c"), 3),
                (("c", "b"), 1)
            ],
            defaultWeight: nil
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
        weights: [((String, String), Int)] = [],
        defaultWeight: Int? = 1,
        file: StaticString = #file,
        line: UInt = #line

    ) {

        expectToBuild(

            [route],
            from: from,
            to: to,
            with: connections,
            weights: weights,
            defaultWeight: defaultWeight,
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
        weights: [((String, String), Int)] = [],
        defaultWeight: Int? = 1,
        resultFilter: @escaping ([Route<String, Int>]) -> [Route<String, Int>] = { $0 },
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let sut = self.makeSUT()
            let calculator = WeightCalculatorStub(weights, default: defaultWeight)

            let result = try await sut.build(

                from: from,
                to: to,
                connections: connections,
                weightCalculator: calculator.weight(for:)
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
