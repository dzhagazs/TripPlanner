//
//  RouteBuilder.swift
//  TripPlannerCore
//
//  Created by Olexandr Vasildzhahaz on 25.01.2024.
//

protocol RouteBuilder {

    associatedtype Weight: Number
    associatedtype RouteElement: Hashable, Equatable

    // I still need weight calculator to be async, but this should be the users responsibility to collect all needed weights
//    typealias WeightCalculator = ((RouteElement, RouteElement)) async throws -> Weight

    static func build(

        from: RouteElement,
        to: RouteElement,
        connections: [(RouteElement, RouteElement, Weight)]

    ) throws -> [Route<RouteElement, Weight>]
}

protocol Addable {

    static func +(lhs: Self, rhs: Self) -> Self
}

protocol Number: Comparable, Addable {

    static var upperBound: Self { get }
    static var zero: Self { get }
}
