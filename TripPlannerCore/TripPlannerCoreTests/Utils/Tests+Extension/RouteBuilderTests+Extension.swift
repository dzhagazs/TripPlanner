//
//  ShortestRouteBuilderTests+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Olexandr Vasildzhahaz on 27.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension ShortestRouteBuilderTests {

    func expectToBuild(

        _ route: Route<String, Int>,
        from: String = "a",
        to: String = "b",
        with connections: [(String, String, Int)],
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let result = try SUT.build(

                from: from,
                to: to,
                connections: connections
            )

            XCTAssertEqual(route, result, file: file, line: line)
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

            _ = try SUT.build(

                from: from,
                to: to,
                connections: connections
            )
        }
    }
}
