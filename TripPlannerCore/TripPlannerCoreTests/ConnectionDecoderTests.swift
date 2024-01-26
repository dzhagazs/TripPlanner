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

            let connections = try sut.decode("{\"connections\": []}".data(using: .utf8)!)

            XCTAssertEqual(connections, [])
        }
    }

    func test_decode_oneReturnsOneConnection() {

        execute {

            let sut = self.makeSUT()

            let connections = try sut.decode("{\"connections\": [\(self.anyConnection().asString)]}".data(using: .utf8)!)

            XCTAssertEqual(connections, [self.anyConnection()])
        }
    }

    // MARK: Private

    private func makeSUT() -> SUT {

        let sut = ConnectionDecoderImpl()

        trackMemoryLeak(for: sut)

        return sut
    }
}

extension Coordinate {

    var asString: String {

        "{\"lat\": \(latitude), \"long\": \(longitude)}"
    }
}

extension Connection {

    var asString: String {

          "{\"from\": \"\(from.name)\",\"to\": \"\(to.name)\", \"coordinates\": {\"from\": \(from.coordinate.asString), \"to\": \(to.coordinate.asString)}, \"price\": 1 }"
    }
}
