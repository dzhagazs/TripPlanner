//
//  Root.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import Foundation

public func start() -> TripPlanner {

    let loader = ConnectionLoaderImpl(

        client: URLSession.shared,
        decoder: ConnectionDecoderImpl(),
        provider: MetadataProviderImpl(distanceCalculator: DistanceCalculator.distance(from:to:))
    )

    var connections: [(Connection, ConnectionMetadata)] = []

    return TripPlannerImpl(

        loader: {

            connections = try await loader.load()

            var places = Set<HashablePlace>()

            connections.forEach { connection in

                places.insert(connection.0.from.hashable)
                places.insert(connection.0.to.hashable)
            }

            return Array(places.map { $0.original })
        },
        validator: { _ in },
        routeBuilder: { from, to in

            try DijkstrasRouteBuilder.build(

                from: from.hashable,
                to: to.hashable,
                connections: connections.map { ($0.0.from.hashable, $0.0.to.hashable, $0.1.price) }
            )

            .map { .init(

                places: $0.path.map { $0.original },
                tags: [.cheapest],
                metrics: [.init(name: RouteMetric.price, value: Float($0.weight))])
            }
        }
    )
}
