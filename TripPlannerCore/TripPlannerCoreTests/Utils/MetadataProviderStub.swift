//
//  MetadataProviderStub.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

final class MetadataProviderStub: MetadataProvider {

    // MARK: MetadataProvider

    func metadata(for connection: Connection) async throws -> ConnectionMetadata {

        try result.get()
    }

    init(result: Result<ConnectionMetadata, Error>) {

        self.result = result
    }

    // MARK: Private

    private let result: Result<ConnectionMetadata, Error>
}

