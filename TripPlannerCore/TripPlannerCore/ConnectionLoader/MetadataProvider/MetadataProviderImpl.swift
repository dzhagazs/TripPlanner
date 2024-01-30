//
//  MetadataProviderImpl.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

final class MetadataProviderImpl: MetadataProvider {

    typealias DistanceCalculator = (Coordinate, Coordinate) -> Float

    // MARK: MetadataProvider

    func metadata(for connection: (Connection, Int)) async throws -> ConnectionMetadata {

        .init(

            price: connection.1,
            approxDistance: distanceCalculator(connection.0.from.coordinate, connection.0.to.coordinate)
        )
    }

    init(

        distanceCalculator: @escaping DistanceCalculator

    ) {

        self.distanceCalculator = distanceCalculator
    }

    // MARK: Private

    private let distanceCalculator: DistanceCalculator
}
