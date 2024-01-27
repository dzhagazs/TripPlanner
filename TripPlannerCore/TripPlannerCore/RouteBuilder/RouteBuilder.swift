//
//  RouteBuilder.swift
//  TripPlannerCore
//
//  Created by Olexandr Vasildzhahaz on 25.01.2024.
//

protocol RouteBuilder {

    associatedtype Weight: Number
    associatedtype RouteElement: Hashable, Equatable

    static func build(

        from: RouteElement,
        to: RouteElement,
        connections: [(RouteElement, RouteElement, Weight)]

    ) throws -> [Route<RouteElement, Weight>]
}

protocol Number: Comparable, Addable {

    static var upperBound: Self { get }
    static var zero: Self { get }
}

protocol Addable {

    static func +(lhs: Self, rhs: Self) -> Self
}
