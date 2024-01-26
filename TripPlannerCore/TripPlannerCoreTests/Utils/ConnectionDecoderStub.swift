//
//  ConnectionDecoderStub.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import Foundation

final class ConnectionDecoderStub: ConnectionDecoder {

    // MARK: ConnectionDecoder

    func decode(_ data: Data) throws -> [Connection] {

        try result.get()
    }

    init(result: Result<[Connection], Error>) {

        self.result = result
    }

    // MARK: Private

    private let result: Result<[Connection], Error>
}
