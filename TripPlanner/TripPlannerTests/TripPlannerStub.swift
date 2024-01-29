//
//  TripPlannerStub.swift
//  TripPlannerTests
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

import TripPlannerCore

final class TripPlannerStub: TripPlanner {

    enum Calls {

        case loadPlaces
        case fromSuggestions(String)
        case toSuggestions(String)
        case selectFrom(String)
        case selectTo(String)
        case clearSelection
        case build
    }

    struct CallResult {

        var loadPlaces: Result<[Place], Error>
        var fromSuggestions: [Place]
        var toSuggestions: [Place]
        var selectFrom: Error?
        var selectTo: Error?
        var build: Result<[PresentableRoute], Error>
    }

    var result: CallResult = .init(

        loadPlaces: .success([]),
        fromSuggestions: [],
        toSuggestions: [],
        build: .success([])
    )

    private(set) var calls: [Calls] = []

    // MARK: TripPlanner

    func loadPlaces() async throws -> [Place] {

        calls.append(.loadPlaces)

        return try result.loadPlaces.get()
    }

    func fromSuggestions(filter: String) -> [Place] {

        calls.append(.fromSuggestions(filter))

        return result.fromSuggestions
    }

    func toSuggestions(filter: String) -> [Place] {

        calls.append(.toSuggestions(filter))

        return result.toSuggestions
    }

    func select(from: Place) throws {

        calls.append(.selectFrom(from.name))

        if let error = result.selectFrom { throw error }
    }

    func select(to: Place) throws {

        calls.append(.selectTo(to.name))

        if let error = result.selectTo { throw error }
    }

    var from: Place?
    var to: Place?

    func clearSelection() {

        calls.append(.clearSelection)
    }

    func build() async throws -> [PresentableRoute] {

        calls.append(.build)

        return try result.build.get()
    }
}
