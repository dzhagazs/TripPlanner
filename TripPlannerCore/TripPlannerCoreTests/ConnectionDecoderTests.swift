//
//  ConnectionDecoderTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class ConnectionDecoderTests: XCTestCase {

    typealias SUT = ConnectionDecoder

    func test_decode_emptyReturnsEmpty() {

        ensureDecodes([])
    }

    func test_decode_oneReturnsOneConnection() {

        ensureDecodes([(self.anyConnection("a", to: "b"), 10)])
    }

    func test_decode_manyReturnsManyConnections() {

        ensureDecodes([

            (self.anyConnection("a", to: "b"), 1),
            (self.anyConnection("b", to: "c"), 2),
            (self.anyConnection("c", to: "d"), 3),
            (self.anyConnection("d", to: "e"), 4)
        ])
    }

    // MARK: Private

    private func makeSUT() -> SUT {

        let sut = ConnectionDecoderImpl()

        trackMemoryLeak(for: sut)

        return sut
    }

    private func ensureDecodes(

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

    private func encodedString(from connections: [(Connection, Int)]) -> String {

        "{\"connections\": [\(connections.map { "{\($0.0.asString)}, \"price\": \($0.1)}" }.joined(separator: ","))]}"
    }
}

extension Coordinate {

    var asString: String {

        "{\"lat\": \(latitude), \"long\": \(longitude)}"
    }
}

extension Connection {

    var asString: String {

        "\"from\": \"\(from.name)\",\"to\": \"\(to.name)\", \"coordinates\": {\"from\": \(from.coordinate.asString), \"to\": \(to.coordinate.asString)"
    }
}
