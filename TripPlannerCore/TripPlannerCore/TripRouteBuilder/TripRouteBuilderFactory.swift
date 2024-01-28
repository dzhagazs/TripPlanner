//
//  TripRouteBuilderFactory.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

final class TripRouteBuilderFactory {

    static func create() -> TripRouteBuilder {

        TripRouteBuilderImpl()
    }
}
