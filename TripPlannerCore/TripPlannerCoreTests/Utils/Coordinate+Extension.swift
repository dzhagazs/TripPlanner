//
//  Coordinate+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

extension Coordinate {

     static let zero = Coordinate(latitude: 0, longitude: 0)
}

extension Coordinate {

    var asString: String {

        "{\"lat\": \(latitude), \"long\": \(longitude)}"
    }
}
