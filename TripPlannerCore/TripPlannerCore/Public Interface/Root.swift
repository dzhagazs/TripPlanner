//
//  Root.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

public func start() -> TripPlanner {

    let places: [Place] = [

        .init(name: "London", coordinate: .init(latitude: 51.5285582, longitude: -0.241681)),
        .init(name: "Tokyo", coordinate: .init(latitude: 35.652832, longitude: 139.839478)),
        .init(name: "Porto", coordinate: .init(latitude: 41.14961, longitude: -8.61099)),
        .init(name: "Sydney", coordinate: .init(latitude: -33.865143, longitude: 151.2099))
    ]

    let priceConnections = [

        (places[0], places[1], 220),
        (places[1], places[0], 200),
        (places[0], places[2], 50),
        (places[1], places[3], 100),
    ]

    return TripPlannerImpl(

        loader: { places },
        validator: { _ in },
        routeBuilder: { from, to in

            try DijkstrasRouteBuilder.build(

                from: from,
                to: to,
                connections: priceConnections).map { .init(

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
