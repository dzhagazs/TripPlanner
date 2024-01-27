//
//  PlaceAnnotation.swift
//  TripPlanner
//
//  Created by Alexandr Vasildzhagaz on 27.01.2024.
//

import CoreLocation.CLLocation

struct PlaceAnnotation {

    let title: String
    let coordinates: CLLocationCoordinate2D
}

extension PlaceAnnotation: Hashable {

    static func == (lhs: PlaceAnnotation, rhs: PlaceAnnotation) -> Bool {

        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(title)
    }
}
