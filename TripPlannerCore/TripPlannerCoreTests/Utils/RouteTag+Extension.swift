//
//  RouteTag+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

extension RouteTag: Equatable {

    public static func == (lhs: RouteTag, rhs: RouteTag) -> Bool {

        lhs.rawValue == rhs.rawValue
    }
}

