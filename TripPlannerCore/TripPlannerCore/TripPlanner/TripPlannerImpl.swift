//
//  TripPlannerImpl.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

final class TripPlannerImpl: TripPlanner {

    typealias Loader = ConnectionLoader
    typealias Validator = ([Place]) throws -> Void
    typealias RouteBuilder = (Place, Place) async throws -> [PresentableRoute]
    typealias Error = TripPlannerError

    // MARK: TripPlanner

    private(set) var from: Place?
    private(set) var to: Place?

    func loadPlaces() async throws -> [Place] {

        let connections = try await loader.load()

        let places = places(from: connections)
        try validator(places)

        self.places = places

        return places
    }

    func fromSuggestions(filter: String) -> [Place] {

        guard let places = places else { return [] }

        return places

            .filter { $0.name.hasPrefix(filter) }
            .filter { $0 != to }
    }

    func toSuggestions(filter: String) -> [Place] {

        guard let places = places else { return [] }

        return places

            .filter { $0.name.hasPrefix(filter) }
            .filter { $0 != from }
    }

    func select(from: Place) throws {

        guard let places = places else { throw Error.notLoaded }
        guard places.first(where: { $0 == from }) != nil else { throw Error.notFound }

        self.from = from
        if to == from {

            to = nil
        }
    }

    func select(to: Place) throws {

        guard let places = places else { throw Error.notLoaded }
        guard places.first(where: { $0 == to }) != nil else { throw Error.notFound }

        self.to = to
        if from == to {

            from = nil
        }
    }

    func clearSelection() {

        from = nil
        to = nil
    }

    func build() async throws -> [PresentableRoute] {

        guard let _ = places else { throw Error.notLoaded }
        guard let from = from, let to = to else { throw Error.incompleteSelection }

        return try await routeBuilder(from, to)
    }

    init(

        loader: Loader,
        validator: @escaping Validator,
        routeBuilder: @escaping RouteBuilder

    ) {

        self.loader = loader
        self.validator = validator
        self.routeBuilder = routeBuilder
    }

    // MARK: Private

    private func places(from connections: [(Connection, ConnectionMetadata)]) -> [Place] {

        var places = Set<HashablePlace>()

        connections.forEach { connection in

            places.insert(connection.0.from.hashable)
            places.insert(connection.0.to.hashable)
        }

        return Array(places.map { $0.original }).sorted(by: { $0.name < $1.name })
    }

    private let loader: Loader
    private let validator: Validator
    private let routeBuilder: RouteBuilder
    private var places: [Place]? = nil
}
