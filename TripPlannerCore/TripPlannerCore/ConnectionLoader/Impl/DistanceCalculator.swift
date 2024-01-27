//
//  DistanceCalculator.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

import CoreLocation

final class DistanceCalculator {

    static func distance(from: Coordinate, to: Coordinate) -> Float {

        let locationFrom = CLLocation(latitude: Double(from.latitude), longitude: Double(from.longitude))
        let locationTo = CLLocation(latitude: Double(from.latitude), longitude: Double(from.longitude))

        return Float(locationFrom.distance(from: locationTo))
    }
}
