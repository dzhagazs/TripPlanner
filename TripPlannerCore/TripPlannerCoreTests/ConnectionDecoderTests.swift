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

    func test_decode_failsOnInvalidData() {

        ensureFailsToDecode("some randome string")
        ensureFailsToDecode("{\"connections\": {} }")
        ensureFailsToDecode("{\"connections\": [{[]}] }")
        ensureFailsToDecode("{\"connection\": [] }")
        ensureFailsToDecode("{\"connections\": [{}] }")
        ensureFailsToDecode("{\"connections\": [{ \"from\": \"\", \"to\": \"\" }] }")
        ensureFailsToDecode("{\"connections\": [{ \"coordinates\": { \"from\": 10, \"to\": 10 } }] }")
        ensureFailsToDecode("{\"connections\": [{ \"from\": \"\", \"to\": \"\", \"coordinates\": { \"from\": 10, \"to\": 10 } }] }")
        ensureFailsToDecode("{\"connections\": [{ \"from\": \"\", \"to\": \"\", \"coordinates\": { \"from\": { \"lat\": 1, \"long\": 2 }, \"to\": { \"lat\": 2, \"long\": 1 } } }] }")
        ensureFailsToDecode(encodedString(from: []) + "}")
        ensureFailsToDecode("{" + encodedString(from: []))
    }
}
