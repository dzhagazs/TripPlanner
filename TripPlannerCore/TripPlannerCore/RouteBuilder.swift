//
//  RouteBuilder.swift
//  TripPlannerCore
//
//  Created by Olexandr Vasildzhagaz on 25.01.2024.
//

protocol RouteBuilder {

    associatedtype Weight: Equatable, Comparable

    typealias Route = ([Place], Weight)
    typealias WeightCalculator = (Connection) async throws -> Weight

    func build(_ connections: [Connection], weightCalculator: WeightCalculator) async throws -> Route
}
