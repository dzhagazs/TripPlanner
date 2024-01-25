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

    // The algorightm returns all possible routes, sorted by weight
    func build(

        from: RouteElement,
        to: RouteElement,
        connections: [(RouteElement, RouteElement)],
        weightCalculator: WeightCalculator

    ) async throws -> [Route<RouteElement, Weight>]
}

struct Route<E, W> {

    let path: [E]
    let weight: W
}

protocol Addable {

    static func +(lhs: Self, rhs: Self) -> Self
}

protocol Number: Comparable, Addable {

    static var upperBound: Self { get }
    static var zero: Self { get }
}
