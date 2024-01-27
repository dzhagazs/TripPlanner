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

            var distance: Float = 0
            let calculator: ((Coordinate, Coordinate) -> Float) = { _, _ in

                distance += 1

                return distance
            }

            let sut = self.makeSUT(distanceCalculator: calculator)
            let connections = [

                (self.anyConnection("a"), 10),
                (self.anyConnection("b"), 20),
                (self.anyConnection("c"), 30),
                (self.anyConnection("d"), 40),
                (self.anyConnection("e"), 50)
            ]

            var index = 1
            try await connections.asyncForEach { connection in

                let metadata = try await sut.metadata(for: connection)

                XCTAssertEqual(metadata, .init(price: index * 10, approxDistance: Float(index)))
                index += 1
            }
        }
    }

    // MARK: Private

    private func makeSUT(

        distanceCalculator: @escaping (Coordinate, Coordinate) -> Float = { _, _ in 1 }

    ) -> SUT {

        MetadataProviderImpl(distanceCalculator: distanceCalculator)
    }
}
