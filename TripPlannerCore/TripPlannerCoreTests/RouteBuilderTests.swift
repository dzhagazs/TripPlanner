//
//  RouteBuilderTests.swift
//  TripPlannerCoreTests
//
//  Created by Olexandr Vasildzhagaz on 25.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class RouteBuilderTests: XCTestCase {

    typealias SUT = RouteBuilder
    typealias WeightCalculator = (Connection) async throws -> UInt

    // MARK: Private

    private static func makeSUT() -> some RouteBuilder {

        DijkstrasRouteBuilder<Int>()
    }
}

final class DijkstrasRouteBuilder<W: Number>: RouteBuilder {

    typealias Weight = W

    func build(_ connections: [Connection], weightCalculator: (Connection) async throws -> Weight) async throws -> Route {
        ([], Weight.zero)
    }
}
