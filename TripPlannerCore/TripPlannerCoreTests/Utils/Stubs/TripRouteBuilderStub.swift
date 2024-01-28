//
//  TripRouteBuilderStub.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

@testable import TripPlannerCore

final class TripRouteBuilderStub: TripRouteBuilder {

    typealias Value = Result<[PresentableRoute], Error>

    init(result: Value) {

        self.result = result
    }

    // MARK: TripRouteBuilder

    func build(

        from: Place,
        to: Place,
        connections: [ConnectionData]

    ) async throws -> [PresentableRoute] {

        try result.get()
    }

    // MARK: Private

    private let result: Value
}
