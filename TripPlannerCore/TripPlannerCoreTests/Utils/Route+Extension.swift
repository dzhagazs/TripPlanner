//
//  Route+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Alexandr Vasildzhagaz on 25.01.2024.
//

@testable import TripPlannerCore

extension Route<String, Int>: Equatable {

    public static func == (lhs: Route, rhs: Route) -> Bool {

        lhs.path == rhs.path && lhs.weight == rhs.weight
    }
}
