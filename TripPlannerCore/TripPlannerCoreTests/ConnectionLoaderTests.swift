//
//  ConnectionLoaderTests.swift
//  TripPlannerCoreTests
//
//  Created by Alexandr Vasildzhagaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class ConnectionLoaderTests: XCTestCase {

    typealias SUT = ConnectionLoader

    // MARK: Private

    private func makeSUT() -> SUT {

        ConnectionLoaderImpl(

            client: <#T##DataSource#>,
            decoder: <#T##ConnectionDecoder#>,
            provider: <#T##MetadataProvider#>
        )
    }
}

final class DataSourceStub: ConnectionDataSource {

    // MARK: DataSource

    func load() async throws -> Data {

        try result.get()
    }

    init(result: Result<Data, Error>) {

        self.result = result
    }

    // MARK: Private

    private let result: Result<Data, Error>
}

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

final class MetadataProviderStub: MetadataProvider {

    // MARK: MetadataProvider

    func metadata(for connection: Connection) async throws -> ConnectionMetadata {

        
    }

    init(result: Result<ConnectionMetadata, Error>) {

        self.result = result
    }

    // MARK: Private

    private let result: Result<ConnectionMetadata, Error>
}
