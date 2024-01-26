//
//  TripPlannerImpl.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

final class TripPlannerImpl: TripPlanner {

    typealias Loader = () async throws -> [Place]
    typealias Error = TripPlannerError

    // MARK: TripPlanner

    private(set) var from: Place?
    private(set) var to: Place?

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
        guard places.first(where: { $0 == from }) != nil else { throw Error.notFound }

        self.from = from
        if to == from {

            to = nil
        }
    }

    func select(to: Place) throws {

        guard let places = places else { throw Error.notLoaded }
        guard places.first(where: { $0 == to }) != nil else { throw Error.notFound }

        self.to = to
        if from == to {

            from = nil
        }
    }

    func clearSelection() {

        from = nil
    }

    func build() async throws -> [PresentableRoute] {

        guard let _ = places else { throw Error.notLoaded }

        return []
    }

    init(loader: @escaping Loader) {

        self.loader = loader
    }

    // MARK: Private

    private let loader: Loader
    private var places: [Place]? = nil
}

extension Place: Equatable {

    public static func == (lhs: Place, rhs: Place) -> Bool {

        lhs.name == rhs.name && lhs.coordinate == rhs.coordinate
    }
}

extension Coordinate: Equatable {

    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {

        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
