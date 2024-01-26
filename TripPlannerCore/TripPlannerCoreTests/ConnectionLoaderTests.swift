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

    private func makeSUT(

        sourceResult: DataSourceStub.Value = .success(Data()),
        decoderResult: ConnectionDecoderStub.Value = .success([]),
        providerResult: MetadataProviderStub.Value = .success(.init(price: 0, approxDistance: 0))

    ) -> SUT {

        ConnectionLoaderImpl(

            client: DataSourceStub(result: sourceResult),
            decoder: ConnectionDecoderStub(result: decoderResult),
            provider: MetadataProviderStub(result: providerResult)
        )
    }
}
