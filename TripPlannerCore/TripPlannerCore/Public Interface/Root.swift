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

            var places = Set<Place>()

            connections.forEach { connection in

                places.insert(connection.0.from)
                places.insert(connection.0.to)
            }

            return Array(places)
        },
        validator: { _ in },
        routeBuilder: { from, to in

            try DijkstrasRouteBuilder.build(

                from: from,
                to: to,
                connections: connections.map { ($0.0.from, $0.0.to, $0.1.price) }).map { .init(

                    places: $0.path,
                    tags: [.cheapest],
                    metrics: [.init(name: RouteMetric.price, value: Float($0.weight))])
                }
        }
    )
}

extension Coordinate: Hashable {

    public func hash(into hasher: inout Hasher) {

        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
extension Place: Hashable {

    public func hash(into hasher: inout Hasher) {

        hasher.combine(name)
        hasher.combine(coordinate)
    }
}
extension Int: Number {

    static var upperBound: Int { .max }
}
