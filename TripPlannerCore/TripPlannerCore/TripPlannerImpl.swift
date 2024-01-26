//
//  TripPlannerImpl.swift
//  TripPlannerCore
//
//  Created by Alexandr Vasildzhagaz on 26.01.2024.
//

final class TripPlannerImpl: TripPlanner {

    typealias Loader = () async throws -> [Place]
    typealias Error = TripPlannerError

    // MARK: TripPlanner

    func loadPlaces() async throws -> [Place] {

        let places = try await loader()

        self.places = places

        return places
    }

    func fromSuggestions(filter: String) -> [Place] {

        []
    }

    func toSuggestions(filter: String) -> [Place] {

        []
    }

    func select(from: Place) throws {

        guard let places = places else { throw Error.notLoaded }
    }

    func select(to: Place) throws {

        guard let places = places else { throw Error.notLoaded }
    }

    func clearSelection() {

        
    }

    func build() async throws -> [PresentableRoute] {

        guard let places = places else { throw Error.notLoaded }

        return []
    }

    init(loader: @escaping Loader) {

        self.loader = loader
    }

    // MARK: Private

    private let loader: Loader

    private var from: Place?
    private var to: Place?
    private var places: [Place]? = nil
}
