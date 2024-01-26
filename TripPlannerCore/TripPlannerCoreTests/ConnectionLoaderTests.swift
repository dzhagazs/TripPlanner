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

    private func makeSUT() -> SUT {

        ConnectionLoaderImpl(

            client: DataSourceStub(result: .success(Data())),
            decoder: ConnectionDecoderStub(result: .success([])),
            provider: MetadataProviderStub(result: .success(.init(price: 0, approxDistance: 0)))
        )
    }
}
