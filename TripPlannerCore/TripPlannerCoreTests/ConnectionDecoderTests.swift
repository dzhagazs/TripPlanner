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

        execute {

            let sut = self.makeSUT()

            let connections = try sut.decode(self.encodedString(from: []).data(using: .utf8)!)

            XCTAssertEqual(connections.map { $0.0 }, [])
            XCTAssertEqual(connections.map { $0.1 }, [])
        }
    }

    func test_decode_oneReturnsOneConnection() {

        execute {

            let sut = self.makeSUT()

            let connections = [self.anyConnection("a", to: "b")]
            let result = try sut.decode(self.encodedString(from: connections.map { ($0, 10) }).data(using: .utf8)!)

            XCTAssertEqual(result.map { $0.0 }, [self.anyConnection("a", to: "b")])
            XCTAssertEqual(result.map { $0.1 }, [10])
        }
    }

    // MARK: Private

    private func makeSUT() -> SUT {

        let sut = ConnectionDecoderImpl()

        trackMemoryLeak(for: sut)

        return sut
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
