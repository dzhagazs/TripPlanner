//
//  TripPlannerTests+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension TripPlannerTests {

    func makeSUT(

        _ connections: [Element] = [],
        loaderError: Error? = nil,
        routeBuilder: @escaping (Place, Place, [(Connection, ConnectionMetadata)]) async throws -> [PresentableRoute] = { _, _, _ in [] }

    ) -> SUT {

        let sut = TripPlannerImpl(

            loader: ConnectionLoaderStub(result: loaderError == nil ? .success(connections) : .failure(loaderError!)),
            routeBuilder: routeBuilder
        )

        trackMemoryLeak(for: sut)

        return sut
    }

    func anyElement(

        _ from: String = "",
        to: String = "",
        price: Int = 0,
        distance: Float = 0

    ) -> Element {

        (anyConnection(from, to: to), anyMetadata(price, distance))
    }
}

