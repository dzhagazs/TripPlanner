//
//  DistanceCalculator.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

import CoreLocation.CLLocation

final class DistanceCalculator {

    static func distance(from: Coordinate, to: Coordinate) -> Float {

        let locationFrom = CLLocation(latitude: Double(from.latitude), longitude: Double(from.longitude))
        let locationTo = CLLocation(latitude: Double(to.latitude), longitude: Double(to.longitude))

        return Float(locationFrom.distance(from: locationTo))
    }
}
