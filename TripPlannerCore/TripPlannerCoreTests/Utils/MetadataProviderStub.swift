//
//  MetadataProviderStub.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

final class MetadataProviderStub: MetadataProvider {

    typealias Value = Result<ConnectionMetadata, Error>

    // MARK: MetadataProvider

    func metadata(for connection: Connection) async throws -> ConnectionMetadata {

        try result.get()
    }

    init(result: Value) {

        self.result = result
    }

    // MARK: Private

    private let result: Value
}

