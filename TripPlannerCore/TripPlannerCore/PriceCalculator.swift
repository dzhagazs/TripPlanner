//
//  PriceCalculator.swift
//  TripPlannerCore
//
//  Created by Alexandr Vasildzhagaz on 25.01.2024.
//

protocol PriceCalculator {

    func price(for connection: Connection) async throws -> Int
}
