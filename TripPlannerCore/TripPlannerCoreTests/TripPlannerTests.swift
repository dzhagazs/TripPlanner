//
//  TripPlannerTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class TripPlannerTests: XCTestCase {

    typealias SUT = TripPlanner
    typealias Error = TripPlannerError

    func test_selectTo_beforeLoadingFails() {

        expectToThrow(Error.notLoaded) {

            try self.makeSUT().select(to: Self.anyPlace())
        }
    }

    func test_selectFrom_beforeLoadingFails() {

        expectToThrow(Error.notLoaded) {

            try self.makeSUT().select(from: Self.anyPlace())
        }
    }

    func test_build_beforeLoadingFails() {

        expectToThrow(Error.notLoaded) {

            _ = try await self.makeSUT().build()
        }
    }

    func test_selectTo_ifToIsEqualToFromClearsFrom() {

        execute {

            let sut = self.makeSUT([Self.anyPlace("a")])

            _ = try await sut.loadPlaces()
            try sut.select(from: Self.anyPlace("a"))
            try sut.select(to: Self.anyPlace("a"))

            XCTAssertNotNil(sut.to)
            XCTAssertNil(sut.from)
        }
    }

    func test_selectFrom_ifFromIsEqualToToClearsTo() {

        execute {

            let sut = self.makeSUT([Self.anyPlace("a")])

            _ = try await sut.loadPlaces()
            try sut.select(to: Self.anyPlace("a"))
            try sut.select(from: Self.anyPlace("a"))

            XCTAssertNotNil(sut.from)
            XCTAssertNil(sut.to)
        }
    }

    func test_selectTo_ifRandomPlaceFails() {

        expectToThrow(Error.notFound) {

            let sut = self.makeSUT([

                Self.anyPlace("a"),
                Self.anyPlace("b")
            ])

            _ = try await sut.loadPlaces()
            try sut.select(to: Self.anyPlace("c"))
        }
    }

    func test_selectFrom_ifRandomPlaceFails() {

        expectToThrow(Error.notFound) {

            let sut = self.makeSUT([

                Self.anyPlace("a"),
                Self.anyPlace("b")
            ])

            _ = try await sut.loadPlaces()
            try sut.select(from: Self.anyPlace("c"))
        }
    }

    func test_clearSelection_clearsFromAndTo() {

        execute {

            let sut = self.makeSUT([

                Self.anyPlace("a"),
                Self.anyPlace("b"),
            ])

            _ = try await sut.loadPlaces()

            try sut.select(to: Self.anyPlace("a"))
            sut.clearSelection()

            XCTAssertNil(sut.to)

            try sut.select(from: Self.anyPlace("a"))
            sut.clearSelection()

            XCTAssertNil(sut.from)

            try sut.select(from: Self.anyPlace("a"))
            try sut.select(to: Self.anyPlace("b"))
            sut.clearSelection()

            XCTAssertNil(sut.from)
            XCTAssertNil(sut.to)
        }
    }

    func test_loadPlaces_forwardsLoaderPlaces() {

        execute {

            let places = [

                Self.anyPlace("a"),
                Self.anyPlace("b"),
            ]
            let sut = self.makeSUT(places)

            let result = try await sut.loadPlaces()

            XCTAssertEqual(places, result)
        }
    }

    func test_loadPlaces_validatesPlaces() {

        execute {

            let places = [

                Self.anyPlace("a"),
                Self.anyPlace("b"),
            ]
            var validationCalls: [[Place]] = []
            let sut = self.makeSUT(places) { validatedPlaces in

                validationCalls.append(validatedPlaces)
            }

            _ = try await sut.loadPlaces()

            XCTAssertEqual(validationCalls, [places])
        }
    }

    func test_loadPlaces_rethrowsLoaderError() {

        expectToThrow(Error.notLoaded) {

            _ = try await self.makeSUT(loaderError: .notLoaded).loadPlaces()
        }
    }

    func test_loadPlaces_rethrowsValidatorError() {

        expectToThrow(Error.notFound) {

            _ = try await self.makeSUT(validator: { _ in throw Error.notFound }).loadPlaces()
        }
    }

    func test_fromSuggestions_filtersPlacesByPrefix() {

        execute {

            let sut = self.makeSUT([

                Self.anyPlace("abc"),
                Self.anyPlace("abca"),
                Self.anyPlace("abcab"),
                Self.anyPlace("abcabc"),
                Self.anyPlace("bcabcab"),
                Self.anyPlace("bcabcabc")
            ])

            _ = try await sut.loadPlaces()

            XCTAssertEqual(sut.fromSuggestions(filter: "abc"), [

                Self.anyPlace("abc"),
                Self.anyPlace("abca"),
                Self.anyPlace("abcab"),
                Self.anyPlace("abcabc")
            ])

            try sut.select(to: Self.anyPlace("abc"))

            XCTAssertEqual(sut.fromSuggestions(filter: "abc"), [

                Self.anyPlace("abca"),
                Self.anyPlace("abcab"),
                Self.anyPlace("abcabc")
            ])
        }
    }

    func test_toSuggestions_filtersPlacesByPrefix() {

        execute {

            let sut = self.makeSUT([

                Self.anyPlace("abc"),
                Self.anyPlace("abca"),
                Self.anyPlace("abcab"),
                Self.anyPlace("abcabc"),
                Self.anyPlace("bcabcab"),
                Self.anyPlace("bcabcabc")
            ])

            _ = try await sut.loadPlaces()

            XCTAssertEqual(sut.toSuggestions(filter: "abc"), [

                Self.anyPlace("abc"),
                Self.anyPlace("abca"),
                Self.anyPlace("abcab"),
                Self.anyPlace("abcabc")
            ])

            try sut.select(from: Self.anyPlace("abc"))

            XCTAssertEqual(sut.toSuggestions(filter: "abc"), [

                Self.anyPlace("abca"),
                Self.anyPlace("abcab"),
                Self.anyPlace("abcabc")
            ])
        }
    }

    func testSuggestionsEmptyBeforeLoading() {

        execute {

            let sut = self.makeSUT([Self.anyPlace("a")])

            XCTAssertEqual(sut.fromSuggestions(filter: ""), [])
            XCTAssertEqual(sut.toSuggestions(filter: ""), [])
        }
    }

    func test_build_withIncompleteSelectionFails() {

        expectToThrow(Error.incompleteSelection) {

            let sut = self.makeSUT([Self.anyPlace()])
            _ = try await sut.loadPlaces()

            try sut.select(to: Self.anyPlace())

            _ = try await sut.build()
        }

        expectToThrow(Error.incompleteSelection) {

            let sut = self.makeSUT([Self.anyPlace()])
            _ = try await sut.loadPlaces()

            try sut.select(from: Self.anyPlace())

            _ = try await sut.build()
        }
    }

    func test_build_forwardsBuilderResult() {

        execute {

            var routeBuilderCalls: [(Place, Place)] = []
            let routeBuilderResult: [PresentableRoute] = [.init(places: [Self.anyPlace("c"), Self.anyPlace("d")], tags: [.cheapest])]

            let sut = self.makeSUT([

                Self.anyPlace("a"),
                Self.anyPlace("b")

            ], routeBuilder: { from, to in

                routeBuilderCalls.append((from, to))

                return routeBuilderResult
            })

            _ = try await sut.loadPlaces()
            try sut.select(to: Self.anyPlace("a"))
            try sut.select(from: Self.anyPlace("b"))

            let routes = try await sut.build()

            XCTAssertEqual(routeBuilderResult, routes)
        }
    }

    func test_build_forwardsBuilderError() {

        expectToThrow(Error.notFound) {

            var routeBuilderCalls: [(Place, Place)] = []

            let sut = self.makeSUT([

                Self.anyPlace("a"),
                Self.anyPlace("b")

            ], routeBuilder: {from, to in

                routeBuilderCalls.append((from, to))

                throw Error.notFound
            })

            _ = try await sut.loadPlaces()
            try sut.select(to: Self.anyPlace("a"))
            try sut.select(from: Self.anyPlace("b"))

            _ = try await sut.build()
        }
    }

    // MARK: Private

    private func makeSUT(

        _ places: [Place] = [],
        loaderError: Error? = nil,
        validator: @escaping ([Place]) throws -> Void = { _ in },
        routeBuilder: @escaping (Place, Place) async throws -> [PresentableRoute] = { _, _ in [] }

    ) -> SUT {

        let sut = TripPlannerImpl(

            loader: {

                if let error = loaderError { throw error }

                return places
            },
            validator: validator,
            routeBuilder: routeBuilder
        )

        trackMemoryLeak(for: sut)

        return sut
    }

    private static func anyCoordinate(lat: Float = 0, lon: Float = 0) -> Coordinate {

        .init(latitude: lat, longitude: lon)
    }
}

extension Coordinate {

     static let zero = Coordinate(latitude: 0, longitude: 0)
}

extension PresentableRoute: Equatable {

    public static func == (lhs: TripPlannerCore.PresentableRoute, rhs: TripPlannerCore.PresentableRoute) -> Bool {

        lhs.places == rhs.places && lhs.tags == rhs.tags
    }
}

extension RouteTag: Equatable {

    public static func == (lhs: RouteTag, rhs: RouteTag) -> Bool {

        lhs.rawValue == rhs.rawValue
    }
}
