//
//  TripPlanner.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

public protocol TripPlanner {

    func loadPlaces() async throws -> [Place]

    func fromSuggestions(filter: String) -> [Place]
    func toSuggestions(filter: String) -> [Place]

    func select(from: Place) throws
    func select(to: Place) throws

    var from: Place? { get }
    var to: Place? { get } 

    func clearSelection()

    func build() async throws -> [PresentableRoute]
}

public struct RouteTag {

    public let rawValue: String
}

extension RouteTag {

    public static let cheapest = RouteTag(rawValue: "cheapest")
}

extension RouteTag {

    public static let shortest = RouteTag(rawValue: "shortest")
}

public struct PresentableRoute {

    public let places: [Place]
    public let tags: [RouteTag]
    public let metrics: [RouteMetric]
}

public struct RouteMetric {

    public let name: String
    public let value: Float
}

extension RouteMetric {

    static let price = "price"
}

public enum TripPlannerError: Swift.Error {

    case notLoaded
    case notFound
    case incompleteSelection
}
