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

    func build(

        from: E,
        to: E,
        connections: [Connection],
        weightCalculator: (Connection) async throws -> W

    ) async throws -> [Route<E, W>] {

        func lowestWeightElement(_ weights: [E: W], processed: [E]) -> E? {

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

        func directNeighbors(for element: E, with connections: [Connection]) -> [E] {

            var neighbors: [E] = []
            connections.forEach { connection in

                if connection.0 == element {

                    neighbors.append(connection.1)
                }
            }

            return neighbors
        }

        guard connections.isEmpty == false else { return [] }
        try validate(from: from, to: to, connections: connections)

        let nodes = getAllNodes(from: connections)
        var graph: [E: [E: W]] = [:]
        nodes.forEach { graph[$0] = [:] }
        var weights: [E: W] = [:]
        var parents: [E: E] = [:]
        var processed: [E] = []

        // Fill initial graph
        // Fill initial weights
        try await nodes.asyncForEach { node in

            let neighbors = directNeighbors(for: node, with: connections)
            var neighborsWeights: [E: W] = [:]
            try await neighbors.asyncForEach { neighbor in

                let weight = try await weightCalculator((node, neighbor))

                guard weight >= 0 else { throw Error.invalidWeight }

                neighborsWeights[neighbor] = weight
            }

            graph[node] = neighborsWeights
            weights[node] = .upperBound
        }

        var processedElement = lowestWeightElement(weights, processed: processed)
        repeat {

            guard let element = processedElement else { break }

            let weight = weights[element]
            let neighbors = graph[element]
            neighbors?.keys.forEach { neighbor in

                let newWeight = weight! + neighbors![neighbor]!
                if weights[neighbor]! > newWeight {

                    weights[neighbor] = newWeight
                    parents[neighbor] = element
                }
            }
            processed.append(element)
            processedElement = lowestWeightElement(weights, processed: processed)

        } while processedElement != nil

        return [.init(path: [], weight: W.zero)]
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

    private func getAllNodes(from connections: [Connection]) -> [E] {

        connections.reduce(NSMutableOrderedSet()) {

            $0.add($1.0)
            $0.add($1.1)

            return $0

        }.array as! [E]
    }
}
