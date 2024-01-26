//
//  ConnectionLoaderTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class ConnectionLoaderTests: XCTestCase {

    typealias SUT = ConnectionLoader

    // MARK: Private

    private func expectToLoad(

        _ connections: [Connection],
        on sut: SUT,
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let result = try await sut.load()

            XCTAssertEqual(connections, result, file: file, line: line)
        }
    }

    private func expectToFail<E: Error & Equatable>(

        _ error: E,
        on sut: SUT,
        file: StaticString = #file,
        line: UInt = #line

    ) {

        expectToThrow(error, file: file, line: line) {

            _ = try await sut.load()
        }
    }

    private func makeSUT(

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
