//
//  ConnectionLoaderStub.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class ConnectionLoaderStub: ConnectionLoader {

    typealias Value = Result<[(Connection, ConnectionMetadata)], Error>

    // MARK: ConnectionLoader

    func load() async throws -> [(Connection, ConnectionMetadata)] {

        try result.get()
    }

    init(result: Value) {

        self.result = result
    }

    // MARK: Private

    private let result: Value
}
