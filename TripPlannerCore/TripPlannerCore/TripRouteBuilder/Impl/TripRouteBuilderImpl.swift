//
//  TripRouteBuilderImpl.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

final class TripRouteBuilderImpl: TripRouteBuilder {

    // MARK: TripRouteBuilder

    func build(

        from: Place,
        to: Place,
        connections: [ConnectionData]

    ) async throws -> [PresentableRoute] {

        let cheapest = try DijkstrasRouteBuilder.build(

        from: from.hashable,
        to: to.hashable,
        connections: connections.map { ($0.0.from.hashable, $0.0.to.hashable, $0.1.price) })

        let shortest = try DijkstrasRouteBuilder.build(

        from: from.hashable,
        to: to.hashable,
        connections: connections.map { ($0.0.from.hashable, $0.0.to.hashable, $0.1.approxDistance) })

        return mergedRoutesIfEqualPaths(

            cheapest: cheapest,
            shortest: shortest,
            connections: connections
        )
    }

    // MARK: Private

    private func mergedRoutesIfEqualPaths(

        cheapest: Route<HashablePlace, Int>,
        shortest: Route<HashablePlace, Float>,
        connections: [ConnectionData]

    ) -> [PresentableRoute] {

        let cheapestPath = cheapest.path
        let shortestPath = shortest.path

        if cheapestPath == shortestPath {

            return [

                .init(

                    places: cheapestPath.map { $0.original },
                    tags: [.cheapest, .shortest],
                    metrics: [

                        .init(name: RouteMetric.price, value: Float(cheapest.weight)),
                        .init(name: RouteMetric.distance, value: shortest.weight)
                    ]
                )
            ]

        } else {

            return [

                .init(

                    places: cheapestPath.map { $0.original },
                    tags: [.cheapest],
                    metrics: [

                        .init(name: RouteMetric.price, value: Float(cheapest.weight)),
                        .init(name: RouteMetric.distance, value: distance(with: cheapestPath.map { $0.original }, connections: connections))
                    ]
                ),

                .init(

                    places: shortestPath.map { $0.original },
                    tags: [.shortest],
                    metrics: [

                        .init(name: RouteMetric.price, value: Float(price(with: cheapestPath.map { $0.original }, connections: connections))),
                        .init(name: RouteMetric.distance, value: shortest.weight)
                    ]
                )
            ]
        }
    }

    private func price(with path: [Place], connections: [ConnectionData]) -> Int {

        pathConnections(with: path, connections: connections).reduce(0) { $0 + $1.1.price }
    }

    private func distance(with path: [Place], connections: [ConnectionData]) -> Float {

        pathConnections(with: path, connections: connections).reduce(0) { $0 + $1.1.approxDistance }
    }

    private func pathConnections(

        with path: [Place],
        connections: [ConnectionData]

    ) -> [ConnectionData] {

        var pathConnections: [ConnectionData] = []

        for index in 1..<path.count {

            if let match = connections.first(where: { $0.0.from == path[index - 1] && $0.0.to == path[index] }) {

                pathConnections.append(match)
            }
        }

        return pathConnections
    }
}
