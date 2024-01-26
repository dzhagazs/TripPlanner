//
//  PriceCalculator.swift
//  TripPlannerCore
//
//  Created by Olexandr Vasildzhahaz on 25.01.2024.
//

protocol PriceCalculator {

    func price(for connection: Connection) async throws -> Int
}
