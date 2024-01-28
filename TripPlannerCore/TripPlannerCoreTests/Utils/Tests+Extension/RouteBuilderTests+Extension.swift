//
//  RouteBuilderTests+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Olexandr Vasildzhahaz on 27.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension RouteBuilderTests {

    func expectToBuildFirst(

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

    func expectToBuild(

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

    func expectToFail(

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
