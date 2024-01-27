//
//  MetadataProviderTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class MetadataProviderTests: XCTestCase {

    typealias SUT = MetadataProvider

    func test_metadata_isCorrectForConnection() {

        execute {

            let sut = self.makeSUT()

            let result = try await sut.metadata(for: (self.anyConnection(), 10))

            XCTAssertEqual(result, .init(price: 10, approxDistance: 1))
        }
    }

    // MARK: Private

    private func makeSUT(

        distanceCalculator: @escaping (Coordinate, Coordinate) -> Float = { _, _ in 1 }

    ) -> SUT {

        MetadataProviderImpl(distanceCalculator: distanceCalculator)
    }
}
