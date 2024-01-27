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
    typealias Error = TestError

    func test_load_forwardsConnections() {

        expectToLoad(

            [

                (anyConnection("a"), anyMetadata(1, 2)),
                (anyConnection("b"), anyMetadata(1, 2)),

            ],
            on: makeSUT(

                decoderResult: .success([

                    (anyConnection("a"), 1),
                    (anyConnection("b"), 1)
                ]),
                providerResult: .success(anyMetadata(1, 2))
            )
        )
    }

    func test_load_forwardsDataSourceError() {

        expectToFail(

            Error.first,
            on: makeSUT(sourceResult: .failure(Error.first))
        )
    }

    func test_load_forwardsDecoderError() {

        expectToFail(

            Error.first,
            on: makeSUT(decoderResult: .failure(Error.first))
        )
    }

    func test_load_forwardsProviderError() {

        expectToFail(

            Error.first,
            on: makeSUT(

                decoderResult: .success([(anyConnection(), 1)]),
                providerResult: .failure(Error.first)
            )
        )
    }
}
