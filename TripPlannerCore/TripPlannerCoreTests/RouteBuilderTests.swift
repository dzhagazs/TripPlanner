//
//  RouteBuilderTests.swift
//  TripPlannerCoreTests
//
//  Created by Olexandr Vasildzhagaz on 25.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class RouteBuilderTests: XCTestCase {

    typealias SUT = DijkstrasRouteBuilder<Int, String>
    typealias Error = RouteBuilderError

    func test_build_returnsOriginalConnectionIfPointsAreConnected() {

        execute {

            let sut = Self.makeSUT()

            let routes = try await sut.build(

                from: "a",
                to: "b",
                connections: [("a", "b")],
                weightCalculator: { _ in 1 }
            )

            XCTAssertEqual(routes, [Route(path: ["a", "b"], weight: 1)])
        }
    }

    func test_build_returnsEmptyForEmptyInput() {

        execute {

            let sut = Self.makeSUT()

            let routes = try await sut.build(

                from: "a",
                to: "b",
                connections: [],
                weightCalculator: { _ in 1 }
            )

            XCTAssertEqual(routes, [])
        }
    }

    func test_build_failsIfToIsNotInGraph() {

        expectToThrow(Error.toNotFound) {

            let sut = Self.makeSUT()

            let _ = try await sut.build(

                from: "a",
                to: "b",
                connections: [("a", "c")],
                weightCalculator: { _ in 1 }
            )
        }
    }

    func test_build_failsIfFromIsNotInGraph() {

        expectToThrow(Error.toNotFound) {

            let sut = Self.makeSUT()

            let _ = try await sut.build(

                from: "a",
                to: "b",
                connections: [("c", "b")],
                weightCalculator: { _ in 1 }
            )
        }
    }

    // MARK: Private

    private static func makeSUT() -> SUT { .init() }
}

extension Int: Number {

    public static var upperBound: Self { .max }
    public static var zero: Self { 0 }
}

extension Route<String, Int>: Equatable {

    public static func == (lhs: Route, rhs: Route) -> Bool {

        lhs.path == rhs.path && lhs.weight == rhs.weight
    }
}

enum RouteBuilderError: Swift.Error, Equatable {

    case toNotFound
    case fromNotFound
}

final class DijkstrasRouteBuilder<W: Number, E: Hashable>: RouteBuilder {

    typealias Weight = W
    typealias RouteElement = E
    typealias Error = RouteBuilderError

    func build(

        from: E,
        to: E,
        connections: [(E, E)],
        weightCalculator: ((E, E)) async throws -> W

    ) async throws -> [Route<E, W>] {

        guard connections.isEmpty == false else { return [] }
        guard connections.first(where: { $0.1 == to }) != nil else { throw Error.toNotFound }

        let weight = try await weightCalculator(connections.first!)

        return [.init(path: [connections.first!.0, connections.first!.1], weight: weight)]
    }
}
