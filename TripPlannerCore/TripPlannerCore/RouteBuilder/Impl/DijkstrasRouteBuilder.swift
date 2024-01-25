//
//  DijkstrasRouteBuilder.swift
//  TripPlannerCore
//
//  Created by Alexandr Vasildzhagaz on 25.01.2024.
//

internal final class DijkstrasRouteBuilder<W: Number, E: Hashable>: RouteBuilder {

    typealias Weight = W
    typealias RouteElement = E
    typealias Error = RouteBuilderError

    func build(

        from: E,
        to: E,
        connections: [(E, E)],
        weightCalculator: ((E, E)) async throws -> W

    ) async throws -> [Route<E, W>] {

        guard connections.isEmpty == false else { return [] }
        try validate(from: from, to: to, connections: connections)

        let weight = try await weightCalculator(connections.first!)

        return [.init(path: [connections.first!.0, connections.first!.1], weight: weight)]
    }

    // MARK: Private

    private func validate(

        from: E,
        to: E,
        connections: [(E, E)]

    ) throws {

        guard connections.first(where: { $0.1 == to }) != nil else { throw Error.toNotFound }
        guard connections.first(where: { $0.0 == from }) != nil else { throw Error.fromNotFound }
    }
}

