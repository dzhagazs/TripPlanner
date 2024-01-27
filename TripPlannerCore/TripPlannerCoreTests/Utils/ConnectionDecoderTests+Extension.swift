//
//  ConnectionDecoderTests+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension ConnectionDecoderTests {

    func makeSUT() -> SUT {

        let sut = ConnectionDecoderImpl()

        trackMemoryLeak(for: sut)

        return sut
    }

    func ensureDecodes(

        _ connections: [(Connection, Int)],
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let result = try self.makeSUT().decode(self.encodedString(from: connections).data(using: .utf8)!)

            XCTAssertEqual(result.map { $0.0 }, connections.map { $0.0 }, file: file, line: line)
            XCTAssertEqual(result.map { $0.1 }, connections.map { $0.1 }, file: file, line: line)
        }
    }

    func ensureFailsToDecode(

        _ encoded: String,
        file: StaticString = #file,
        line: UInt = #line

    ) {

        expectToThrow(file: file, line: line) {

            _ = try self.makeSUT().decode(encoded.data(using: .utf8)!)
        }
    }

    func encodedString(from connections: [(Connection, Int)]) -> String {

        "{\"connections\": [\(connections.map { "{\($0.0.asString)}, \"price\": \($0.1)}" }.joined(separator: ","))]}"
    }
}
