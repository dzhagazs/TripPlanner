//
//  RouteTag+Extension.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

import TripPlannerCore

extension RouteTag {

    var value: String {

        switch self {

        case .cheapest: return "cheapest"
        case .shortest: return "shortest"
        default: return ""
        }
    }
}
