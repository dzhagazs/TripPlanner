//
//  TripPlanner.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhagaz on 26.01.2024.
//

public protocol TripPlanner {

    func loadPlaces() async throws

    func fromSuggestions(filter: String) -> [Place]
    func toSuggestions(filter: String) -> [Place]

    func set(from: Place) throws
    func set(to: Place) throws

    func build() async throws -> [PresentableRoute]
}

public struct RouteTag {

    public let rawValue: String
}

extension RouteTag {

    static let cheapest = RouteTag(rawValue: "cheapest")
}

extension RouteTag {

    static let shortest = RouteTag(rawValue: "shortest")
}

public struct PresentableRoute {

    public let places: [Place]
    public let tags: [RouteTag]
}
