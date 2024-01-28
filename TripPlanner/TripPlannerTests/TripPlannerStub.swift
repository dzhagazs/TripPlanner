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

        []
    }

    func fromSuggestions(filter: String) -> [Place] {

        []
    }

    func toSuggestions(filter: String) -> [Place] {

        []
    }

    func select(from: Place) throws {

    }

    func select(to: Place) throws {

        
    }

    var from: Place?
    var to: Place?

    func clearSelection() {

        
    }

    func build() async throws -> [PresentableRoute] {

        []
    }
}
