//
//  RouteBuilder.swift
//  TripPlannerCore
//
//  Created by Olexandr Vasildzhagaz on 25.01.2024.
//

protocol RouteBuilder {

    associatedtype Weight: Number

    typealias Route = ([Place], Weight)
    typealias WeightCalculator = (Connection) async throws -> Weight

    func build(_ connections: [Connection], weightCalculator: WeightCalculator) async throws -> Route
}

protocol Number: Comparable {

    static var upperBound: Self { get }
    static var zero: Self { get }
}

extension Int: Number {

    static var upperBound: Int { .max }
    static var zero: Int { 0 }
}

extension Float: Number {

    static var upperBound: Float { .infinity }
    public static var zero: Float { 0 }
}
