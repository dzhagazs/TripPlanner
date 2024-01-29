//
//  Array+Extension.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 29.01.2024.
//

import TripPlannerCore

extension Array where Element == Place {

    var asAnnotations: [PlaceAnnotation] {

        self.map { .init(

            title: $0.name,
            coordinates: .init(

                latitude: Double($0.coordinate.latitude),
                longitude: Double($0.coordinate.longitude)))
        }
    }
}
