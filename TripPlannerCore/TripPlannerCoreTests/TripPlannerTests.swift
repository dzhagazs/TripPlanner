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

    func test_clearSelection_clearsFrom() {

        execute {

            let sut = self.makeSUT([Self.anyPlace("a")])

            let _ = try await sut.loadPlaces()
            try sut.select(from: Self.anyPlace("a"))

            sut.clearSelection()

            XCTAssertNil(sut.from)
        }
    }

    // MARK: Private

    private func makeSUT(_ places: [Place] = []) -> SUT {

        let sut = TripPlannerImpl(loader: { places })

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
