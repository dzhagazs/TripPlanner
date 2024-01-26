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

            let _ = try await self.makeSUT().build()
        }
    }

    func test_selectTo_ifToIsEqualToFromClearsFrom() {

        execute {

            let sut = self.makeSUT([Self.anyPlace("a")])

            let _ = try await sut.loadPlaces()
            try sut.select(from: Self.anyPlace("a"))
            try sut.select(to: Self.anyPlace("a"))

            XCTAssertNotNil(sut.to)
            XCTAssertNil(sut.from)
        }
    }

    func test_selectFrom_ifFromIsEqualToToClearsTo() {

        execute {

            let sut = self.makeSUT([Self.anyPlace("a")])

            let _ = try await sut.loadPlaces()
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

            let _ = try await sut.loadPlaces()
            try sut.select(to: Self.anyPlace("c"))
        }
    }

    func test_selectFrom_ifRandomPlaceFails() {

        expectToThrow(Error.notFound) {

            let sut = self.makeSUT([

                Self.anyPlace("a"),
                Self.anyPlace("b")
            ])

            let _ = try await sut.loadPlaces()
            try sut.select(from: Self.anyPlace("c"))
        }
    }

    func test_clearSelection_clearsFromAndTo() {

        execute {

            let sut = self.makeSUT([

                Self.anyPlace("a"),
                Self.anyPlace("b"),
            ])

            let _ = try await sut.loadPlaces()

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

            let _ = try await sut.loadPlaces()

            XCTAssertEqual(validationCalls, [places])
        }
    }

    func test_loadPlaces_rethrowsLoaderError() {

        expectToThrow(Error.notLoaded) {

            let _ = try await self.makeSUT(loaderError: .notLoaded).loadPlaces()
        }
    }

    func test_loadPlaces_rethrowsValidatorError() {

        expectToThrow(Error.notFound) {

            let _ = try await self.makeSUT(validator: { _ in throw Error.notFound }).loadPlaces()
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

            let _ = try await sut.loadPlaces()

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

            let _ = try await sut.loadPlaces()

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
            let _ = try await sut.loadPlaces()

            try sut.select(to: Self.anyPlace())

            let _ = try await sut.build()
        }

        expectToThrow(Error.incompleteSelection) {

            let sut = self.makeSUT([Self.anyPlace()])
            let _ = try await sut.loadPlaces()

            try sut.select(from: Self.anyPlace())

            let _ = try await sut.build()
        }
    }

    // MARK: Private

    private func makeSUT(

        _ places: [Place] = [],
        loaderError: Error? = nil,
        validator: @escaping ([Place]) throws -> Void = { _ in }

    ) -> SUT {

        let sut = TripPlannerImpl(

            loader: {

                if let error = loaderError { throw error }

                return places
            },
            validator: validator,
            routeBuilder: { _, _ in [] }
        )

        trackMemoryLeak(for: sut)

        return sut
    }

    private static func anyPlace(

        _ name: String = "",
        coordinate: Coordinate = .zero

    ) -> Place {

        .init(name: name, coordinate: coordinate)
    }

    private static func anyCoordinate(lat: Float = 0, lon: Float = 0) -> Coordinate {

        .init(latitude: lat, longitude: lon)
    }
}

extension Coordinate {

     static let zero = Coordinate(latitude: 0, longitude: 0)
}
