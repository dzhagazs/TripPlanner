//
//  Connection+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

extension Connection: Equatable {

    public static func == (lhs: Connection, rhs: Connection) -> Bool {

        lhs.from == rhs.from && lhs.to == rhs.to
    }
}
