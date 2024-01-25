//
//  RouteBuilder.swift
//  TripPlannerCore
//
//  Created by Olexandr Vasildzhagaz on 25.01.2024.
//

protocol RouteBuilder {

    associatedtype Weight: Number
    associatedtype RouteElement: Hashable, Equatable

    typealias WeightCalculator = ((RouteElement, RouteElement)) async throws -> Weight

    func build(

        from: RouteElement,
        to: RouteElement,
        connections: [(RouteElement, RouteElement)],
        weightCalculator: WeightCalculator

    ) async throws -> Route<RouteElement, Weight>
}

struct Route<E, W> {

    let path: [E]
    let weight: W
}

protocol Number: Comparable {

    static var upperBound: Self { get }
    static var zero: Self { get }
}
