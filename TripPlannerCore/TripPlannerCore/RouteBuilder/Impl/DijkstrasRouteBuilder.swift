//
//  DijkstrasRouteBuilder.swift
//  TripPlannerCore
//
//  Created by Alexandr Vasildzhagaz on 25.01.2024.
//

import Foundation

internal final class DijkstrasRouteBuilder<W: Number, E: Hashable>: RouteBuilder {

    typealias Weight = W
    typealias RouteElement = E
    typealias Error = RouteBuilderError
    typealias Connection = (E, E, W)

    static func build(

        from: E,
        to: E,
        connections: [Connection]

    ) throws -> [Route<E, W>] {

        try validate(from: from, to: to, connections: connections)

        let filteredNodes = getAllNodes(from: connections, ignored: [from])
        let allNodes = [from] + filteredNodes

        let fromNeighbors = directNeighbors(for: from, with: connections)
        var weights = initialWeights(for: from, fromNeighbors: fromNeighbors, filteredNodes: filteredNodes)
        var parents = initialParents(for: from, fromNeighbors: fromNeighbors)

        var routes = initialRoutes(from: from, to: to, connections: connections)

        let graph = try initialGraph(for: allNodes, connections: connections)

        fill(

            with: graph,
            from: from,
            to: to,
            routes: &routes,
            weights: &weights,
            parents: &parents
        )

        guard routes.count > 0 else { throw Error.notFound }

        return routes.sorted(by: { $0.weight < $1.weight })
    }

    // MARK: Private

    private static func fill(

        with graph: [E: [E: W]],
        from: E,
        to: E,
        routes: inout [Route<E, W>],
        weights: inout [E: W],
        parents: inout [E: E]
    ) {

        var processed: [E] = []
        var processedElement = Self.lowestWeightElement(weights, processed: processed)

        repeat {

            guard let element = processedElement else { break }

            let weight = weights[element]
            let neighbors = graph[element]
            neighbors?.keys.forEach { neighbor in

                let newWeight = weight! + neighbors![neighbor]!
                if weights[neighbor]! > newWeight {

                    weights[neighbor] = newWeight
                    parents[neighbor] = element
                    if weights[to]! < .upperBound {

                        routes.append(.init(

                            path: [from] + Self.path(from: from, to: to, parents: parents),
                            weight: weights[to]!
                        ))
                    }
                }
            }
            processed.append(element)
            processedElement = Self.lowestWeightElement(weights, processed: processed)

        } while processedElement != nil
    }

    private static func initialGraph(for nodes: [E], connections: [Connection]) throws -> [E: [E: W]] {

        var graph: [E: [E: W]] = [:]

        // Fill initial graph
        try nodes.forEach { node in

            let neighbors = Self.directNeighbors(for: node, with: connections)
            var neighborsWeights: [E: W] = [:]
            try neighbors.forEach { neighbor in

                let weight = neighbor.2

                guard weight >= .zero else { throw Error.invalidWeight }

                neighborsWeights[neighbor.1] = weight
            }

            graph[node] = neighborsWeights
        }

        return graph
    }

    private static func initialRoutes(from: E, to: E, connections: [Connection]) -> [Route<E, W>] {

        var routes: [Route<E, W>] = []

        if let direct = directConnectionRouteIfExists(from: from, to: to, connections: connections) {

            routes.append(direct)
        }

        return routes
    }

    private static func directConnectionRouteIfExists(

        from: E,
        to: E,
        connections: [Connection]

    ) -> Route<E, W>? {

        guard let directConnection = connections.first(where: { $0.0 == from && $0.1 == to }) else { return nil }

        return .init(path: [from, to], weight: directConnection.2)
    }

    private static func initialWeights(

        for from: E, 
        fromNeighbors: [Connection],
        filteredNodes: [E]

    ) -> [E: W] {

        var weights: [E: W] = [:]

        // Fill initial weights
        filteredNodes.forEach { weights[$0] = .upperBound }

        // Fill start direct neighbors weights
        fromNeighbors.forEach { fromNeighbor in

            let weight = fromNeighbor.2
            weights[fromNeighbor.1] = weight
        }

        return weights
    }

    private static func initialParents(

        for from: E,
        fromNeighbors: [Connection]

    ) -> [E: E] {

        var parents: [E: E] = [:]

        fromNeighbors.forEach { fromNeighbor in

            // Fill start directNeighbors parents
            parents[fromNeighbor.1] = from
        }

        return parents
    }

    private static func lowestWeightElement(_ weights: [E: W], processed: [E]) -> E? {

        var lowestWeight: W = .upperBound
        var result: E? = nil
        weights.forEach { (key, value) in

            let weight = value
            if weight < lowestWeight && processed.contains(where: { $0 == key }) == false {

                lowestWeight = value
                result = key
            }
        }

        return result
    }

    private static func directNeighbors(

        for element: E,
        with connections: [Connection]

    ) -> [Connection] {

        connections.filter { $0.0 == element }
    }

    private static func path(from: E, to: E, parents: [E: E]) -> [E] {

        var path: [E] = []
        var element = to
        repeat {

            path.append(element)
            element = parents[element]!

        } while element != from

        return path.reversed()
    }

    private static func validate(

        from: E,
        to: E,
        connections: [(E, E, W)]

    ) throws {

        guard connections.count > 0 else { throw Error.notFound }
        guard connections.first(where: { $0.1 == to }) != nil else { throw Error.toNotFound }
        guard connections.first(where: { $0.0 == from }) != nil else { throw Error.fromNotFound }
    }

    private static func getAllNodes(from connections: [Connection], ignored: [E]) -> [E] {

        let nodes = connections.reduce(NSMutableOrderedSet()) {

            $0.add($1.0)
            $0.add($1.1)

            return $0
        }

        nodes.minus(NSOrderedSet(array: ignored))

        return nodes.array as! [E]
    }
}
