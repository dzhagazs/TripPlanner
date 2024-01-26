//
//  ConnectionLoaderImpl.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import Foundation

protocol ConnectionDecoder {

    func decode(_ data: Data) throws -> [Connection]
}

protocol MetadataProvider {

    func metadata(for connection: Connection) async throws -> ConnectionMetadata
}

final class ConnectionLoaderImpl: ConnectionLoader {

    init(

        client: ConnectionDataSource,
        decoder: ConnectionDecoder,
        provider: MetadataProvider

    ) {

        self.client = client
        self.decoder = decoder
        self.provider = provider
    }

    // MARK: ConnectionLoader

    func load() async throws -> [(Connection, ConnectionMetadata)] {

        let data = try await client.load()
        let connections = try decoder.decode(data)
        let metadata = try await metadata(from: connections)

        return Array(zip(connections, metadata))
    }

    // MARK: Private

    private func metadata(from connections: [Connection]) async throws -> [ConnectionMetadata] {

        var result: [ConnectionMetadata] = []

        try await connections.asyncForEach { connection in

            let metadata = try await provider.metadata(for: connection)
            result.append(metadata)
        }

        return result
    }

    private let client: ConnectionDataSource
    private let decoder: ConnectionDecoder
    private let provider: MetadataProvider
}
