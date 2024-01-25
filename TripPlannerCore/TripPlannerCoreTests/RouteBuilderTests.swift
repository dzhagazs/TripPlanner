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

        expectToFail(.toNotFound, with: [("a", "c")])
        expectToFail(.toNotFound, with: [("b", "c")])
        expectToFail(.toNotFound, with: [("b", "c"), ("a", "c"), ("d", "a")])
    }

    func test_build_failsIfFromIsNotInGraph() {

        expectToFail(.fromNotFound, with: [("c", "b")])
        expectToFail(.fromNotFound, with: [("d", "b")])
        expectToFail(.fromNotFound, with: [("b", "a"), ("c", "b"), ("d", "a")])
    }

    // MARK: Private

    private static func makeSUT() -> SUT { .init() }

    private func expectToFail(

        _ error: Error,
        from: String = "a",
        to: String = "b",
        with connections: [(String, String)] = [], file: StaticString = #file, line: UInt = #line) {

            expectToThrow(error, file: file, line: line) {

                let sut = Self.makeSUT()

                let _ = try await sut.build(

                    from: from,
                    to: to,
                    connections: connections,
                    weightCalculator: { _ in 1 }
                )
            }
        }
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
        try validate(from: from, to: to, connections: connections)

        let weight = try await weightCalculator(connections.first!)

        return [.init(path: [connections.first!.0, connections.first!.1], weight: weight)]
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
}
