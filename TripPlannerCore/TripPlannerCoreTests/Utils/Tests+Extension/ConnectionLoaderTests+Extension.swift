//
//  ConnectionLoaderTests+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension ConnectionLoaderTests {

    func expectToLoad(

        _ connections: [(Connection, ConnectionMetadata)],
        on sut: SUT,
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let result = try await sut.load()

            XCTAssertEqual(connections.map { $0.0 }, result.map { $0.0 }, file: file, line: line)
            XCTAssertEqual(connections.map { $0.1 }, result.map { $0.1 }, file: file, line: line)
        }
    }

    func expectToFail(

        _ error: Error,
        on sut: SUT,
        file: StaticString = #file,
        line: UInt = #line

    ) {

        expectToThrow(error, file: file, line: line) {

            _ = try await sut.load()
        }
    }

    func makeSUT(

        sourceResult: DataSourceStub.Value = .success(Data()),
        decoderResult: ConnectionDecoderStub.Value = .success([]),
        providerResult: MetadataProviderStub.Value = .success(.init(price: 0, approxDistance: 0))

    ) -> SUT {

        let sut = ConnectionLoaderImpl(

            client: DataSourceStub(result: sourceResult),
            decoder: ConnectionDecoderStub(result: decoderResult),
            provider: MetadataProviderStub(result: providerResult)
        )

        trackMemoryLeak(for: sut)

        return sut
    }
}
