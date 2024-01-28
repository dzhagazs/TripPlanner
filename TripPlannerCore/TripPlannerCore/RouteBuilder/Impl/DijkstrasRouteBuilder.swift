//
//  DijkstrasRouteBuilder.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 25.01.2024.
//

import Foundation

internal final class DijkstrasRouteBuilder<W: Number, E: Hashable>: ShortestRouteBuilder {

    typealias Weight = W
    typealias RouteElement = E
    typealias Error = RouteBuilderError
    typealias Connection = (E, E, W)

    static func build(

        from: E,
        to: E,
        connections: [Connection]

    ) throws -> Route<E, W> {

        try validate(from: from, to: to, connections: connections)

        let allNodes = getAllNodes(from: connections)
        let fromNeighbors = directNeighbors(for: from, with: connections)

        var weights = initialWeights(for: from, fromNeighbors: fromNeighbors, from: allNodes)
        var parents = initialParents(for: from, fromNeighbors: fromNeighbors)

        let graph = try initialGraph(for: allNodes, connections: connections)

        fill(

            with: graph,
            from: from,
            to: to,
            weights: &weights,
            parents: &parents
        )

        let path = try path(from: from, to: to,parents: parents)

        guard let weight = weights[to], !path.isEmpty else { throw Error.notFound}

        return .init(path: path, weight: weight)
    }

    // MARK: Private

    private static func validate(

        from: E,
        to: E,
        connections: [(E, E, W)]

    ) throws {

        guard connections.count > 0 else { throw Error.notFound }
        guard connections.first(where: { $0.1 == to }) != nil else { throw Error.toNotFound }
        guard connections.first(where: { $0.0 == from }) != nil else { throw Error.fromNotFound }
    }

    private static func getAllNodes(from connections: [Connection]) -> [E] {

        connections.reduce(NSMutableOrderedSet()) {

            $0.add($1.0)
            $0.add($1.1)

            return $0

        }.array as! [E]
    }

    private static func directNeighbors(

        for element: E,
        with connections: [Connection]

    ) -> [Connection] {

        connections.filter { $0.0 == element }
    }

    private static func initialWeights(

        for from: E,
        fromNeighbors: [Connection],
        from nodes: [E]

    ) -> [E: W] {

        var weights: [E: W] = [:]

        // Fill initial weights
        nodes.forEach { weights[$0] = .upperBound }

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

    private static func initialGraph(for nodes: [E], connections: [Connection]) throws -> [E: [E: W]] {

        var graph: [E: [E: W]] = [:]

        // Fill initial graph
        try nodes.forEach { node in

            let neighbors = directNeighbors(for: node, with: connections)
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

    private static func fill(

        with graph: [E: [E: W]],
        from: E,
        to: E,
        weights: inout [E: W],
        parents: inout [E: E]
    ) {

        var processed: [E] = []
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

    private static func path(from: E, to: E, parents: [E: E]) throws -> [E] {

        var path: [E] = []
        var element = to
        repeat {

            path.append(element)
            guard let next = parents[element] else { throw Error.notFound }
            element = next

        } while element != from

        path.append(from)

        return path.reversed()
    }
}
