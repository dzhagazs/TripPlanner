//
//  ConnectionLoader.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

protocol ConnectionLoader {

    func load() async throws -> [(Connection, ConnectionMetadata)]
}

struct ConnectionMetadata {

    let price: Int
    let approxDistance: Float
}
