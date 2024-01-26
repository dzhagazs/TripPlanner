//
//  PresentableRoute+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Alexandr Vasildzhagaz on 26.01.2024.
//

@testable import TripPlannerCore

extension PresentableRoute: Equatable {

    public static func == (lhs: TripPlannerCore.PresentableRoute, rhs: TripPlannerCore.PresentableRoute) -> Bool {

        lhs.places == rhs.places && lhs.tags == rhs.tags
    }
}
