//
//  TripPlannerTests.swift
//  TripPlannerCoreTests
//
//  Created by Alexandr Vasildzhagaz on 26.01.2024.
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

    // MARK: Private

    private func makeSUT() -> SUT {

        let sut = TripPlannerImpl(loader: { [] })

        trackMemoryLeak(for: sut)

        return sut
    }

    private static func anyPlace(

        name: String = "",
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
