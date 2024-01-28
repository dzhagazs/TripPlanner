//
//  TripRouteBuilder.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

protocol TripRouteBuilder {

    typealias ConnectionData = (Connection, ConnectionMetadata)

    func build(from: Place, to: Place, connections: [ConnectionData]) async throws -> [PresentableRoute]
}
