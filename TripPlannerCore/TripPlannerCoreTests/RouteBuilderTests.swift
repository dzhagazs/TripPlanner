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
            with: [("a", "b", 1)]
        )
    }

    func test_build_returnsEmptyForEmptyInput() {

        expectToBuild([], with: [])
    }

    func test_build_findsShortestPath1() {

        expectToBuildFirst(

            route: Route(path: ["a", "d", "b"], weight: 2),
            with: [

                ("a", "d", 1),
                ("a", "c", 1),
                ("c", "b", 2),
                ("d", "b", 1)
            ]
        )
    }

    func test_build_findsShortestPath2() {

        expectToBuildFirst(

            route: Route(path: ["a", "d", "c", "b"], weight: 6),
            with: [

                ("a", "d", 2),
                ("a", "c", 6),
                ("d", "b", 6),
                ("d", "c", 3),
                ("c", "b", 1)
            ]
        )
    }

    func test_build_findsShortestPath3() {

        expectToBuildFirst(

            route: Route(path: ["a", "d", "e", "b"], weight: 8),
            with: [

                ("a", "c", 2),
                ("a", "d", 5),
                ("c", "d", 8),
                ("c", "e", 7),
                ("d", "f", 4),
                ("d", "e", 2),
                ("e", "b", 1),
                ("f", "e", 6),
                ("f", "b", 3)
            ]
        )
    }

    func test_build_findsShortestPath4() {

        expectToBuildFirst(

            route: Route(path: ["a", "c", "d", "e", "b"], weight: 4),
            with: [

                ("a", "b", 10),
                ("a", "c", 1),
                ("c", "d", 1),
                ("d", "e", 1),
                ("e", "b", 1)
            ]
        )
    }

    func test_build_findsShortestPath5() {

        expectToBuildFirst(

            route: Route(path: ["a", "f", "g", "h", "b"], weight: 4),
            with: [

                ("a", "b", 10),
                ("a", "c", 2),
                ("c", "d", 2),
                ("d", "e", 2),
                ("e", "b", 2),
                ("a", "f", 1),
                ("f", "g", 1),
                ("g", "h", 1),
                ("h", "b", 1)
            ]
        )
    }

    func test_build_findsShortestPathWithCycle1() {

        expectToBuildFirst(

            route: Route(path: ["a", "c", "d", "b"], weight: 60),
            with: [

                ("a", "c", 10),
                ("c", "d", 20),
                ("d", "e", 1),
                ("e", "c", 1),
                ("d", "b", 30)
            ]
        )
    }

    func test_build_findsShortestPathWithCycle2() {

        expectToBuildFirst(

            route: Route(path: ["a", "e", "b"], weight: 4),
            with: [

                ("a", "c", 2),
                ("a", "e", 2),
                ("c", "e", 2),
                ("e", "b", 2),
                ("e", "d", 2),
                ("d", "b", 2),
                ("d", "c", 1)
            ]
        )
    }

    func test_build_failsIfToIsNotInGraph() {

        expectToFail(.toNotFound, with: [("a", "c", 1)])
        expectToFail(.toNotFound, with: [("b", "c", 1)])
        expectToFail(.toNotFound, with: [

            ("b", "c", 1),
            ("a", "c", 1),
            ("d", "a", 1)
        ])
    }

    func test_build_failsIfFromIsNotInGraph() {

        expectToFail(.fromNotFound, with: [("c", "b", 1)])
        expectToFail(.fromNotFound, with: [("d", "b", 1)])
        expectToFail(.fromNotFound, with: [("b", "a", 1), ("c", "b", 1), ("d", "a", 1)])
    }

    func test_build_failsIfNegativeWeightProvided() {

        expectToFail(.invalidWeight, with: [

            ("a", "c", 1),
            ("c", "d", 1),
            ("c", "b", 1),
            ("d", "b", -1),
        ])

        expectToFail(.invalidWeight, with: [

            ("a", "c", 1),
            ("c", "d", 1),
            ("c", "b", -1),
            ("d", "b", 1),
        ])

        expectToFail(.invalidWeight, with: [

            ("a", "c", 1),
            ("c", "d", -1),
            ("c", "b", 1),
            ("d", "b", 1),
        ])

        expectToFail(.invalidWeight, with: [

            ("a", "c", -1),
            ("c", "d", 1),
            ("c", "b", 1),
            ("d", "b", 1),
        ])
    }

    func test_build_failsIfElementsAreNotConnected() {

        expectToFail(.notFound, with: [

            ("a", "c", 1),
            ("a", "d", 1),
            ("d", "c", 1),
            ("e", "b", 1),
            ("e", "f", 1),
            ("f", "b", 1)
        ])
    }

    // MARK: Private

    private func expectToBuildFirst(

        route: Route<String, Int>,
        from: String = "a",
        to: String = "b",
        with connections: [(String, String, Int)],
        file: StaticString = #file,
        line: UInt = #line

    ) {

        expectToBuild(

            [route],
            from: from,
            to: to,
            with: connections,
            resultFilter: { ($0.first != nil) ? [$0.first!] : [] },
            file: file,
            line: line
        )
    }

    private func expectToBuild(

        _ routes: [Route<String, Int>],
        from: String = "a",
        to: String = "b",
        with connections: [(String, String, Int)],
        resultFilter: @escaping ([Route<String, Int>]) -> [Route<String, Int>] = { $0 },
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let result = try SUT.build(

                from: from,
                to: to,
                connections: connections
            )

            XCTAssertEqual(routes, resultFilter(result), file: file, line: line)
        }
    }

    private func expectToFail(

        _ error: Error,
        from: String = "a",
        to: String = "b",
        with connections: [(String, String, Int)],
        file: StaticString = #file,
        line: UInt = #line

    ) {

        expectToThrow(error, file: file, line: line) {

            let _ = try SUT.build(

                from: from,
                to: to,
                connections: connections
            )
        }
    }
}
