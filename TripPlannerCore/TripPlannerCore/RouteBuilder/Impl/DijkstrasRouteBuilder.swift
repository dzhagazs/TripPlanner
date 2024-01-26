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
    typealias Connection = (E, E)

    static func build(

        from: E,
        to: E,
        connections: [Connection],
        weightCalculator: (Connection) async throws -> W

    ) async throws -> [Route<E, W>] {

        guard connections.isEmpty == false else { return [] }
        try validate(from: from, to: to, connections: connections)

        let filteredNodes = getAllNodes(from: connections, ignored: [from])
        let allNodes = [from] + filteredNodes
        var graph: [E: [E: W]] = [:]
        filteredNodes.forEach { graph[$0] = [:] }
        var weights: [E: W] = [:]
        var parents: [E: E] = [:]
        var processed: [E] = []
        var routes: [Route<E, W>] = []

        // Check for direct connection
        if let _ = connections.first(where: { $0.0 == from && $0.1 == to }) {

            let weight = try await weightCalculator((from, to))
            routes.append(.init(path: [from, to], weight: weight))
        }


        // Fill initial weights
        filteredNodes.forEach { weights[$0] = .upperBound }

        let fromNeighbors = Self.directNeighbors(for: from, with: connections)
        try await fromNeighbors.asyncForEach { fromNeighbor in

            // Fill start direct neighbors weights
            weights[fromNeighbor] = try await weightCalculator((from, fromNeighbor))

            // Fill start directNeighbors parents
            parents[fromNeighbor] = from
        }

        // Fill initial graph
        try await allNodes.asyncForEach { node in

            let neighbors = Self.directNeighbors(for: node, with: connections)
            var neighborsWeights: [E: W] = [:]
            try await neighbors.asyncForEach { neighbor in

                let weight = try await weightCalculator((node, neighbor))

                guard weight >= .zero else { throw Error.invalidWeight }

                neighborsWeights[neighbor] = weight
            }

            graph[node] = neighborsWeights
        }

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

        guard routes.count > 0 else { throw Error.notFound }

        return routes.sorted(by: { $0.weight < $1.weight })
    }

    // MARK: Private

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

    private static func directNeighbors(for element: E, with connections: [Connection]) -> [E] {

        var neighbors: [E] = []
        connections.forEach { connection in

            if connection.0 == element {

                neighbors.append(connection.1)
            }
        }

        return neighbors
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
        connections: [(E, E)]

    ) throws {

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
