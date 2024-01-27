//
//  ConnectionMetadata+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

extension ConnectionMetadata: Equatable {

    public static func == (lhs: ConnectionMetadata, rhs: ConnectionMetadata) -> Bool {

        lhs.price == rhs.price && lhs.approxDistance == rhs.approxDistance
    }
}
