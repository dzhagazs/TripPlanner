//
//  ConnectionDecoderStub.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import Foundation

final class ConnectionDecoderStub: ConnectionDecoder {

    typealias Value = Result<[Connection], Error>

    // MARK: ConnectionDecoder

    func decode(_ data: Data) throws -> [Connection] {

        try result.get()
    }

    init(result: Value) {

        self.result = result
    }

    // MARK: Private

    private let result: Value
}
