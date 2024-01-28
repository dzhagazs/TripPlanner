//
//  PresentableRoute+Extension.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

import CoreLocation.CLLocation

import TripPlannerCore

extension PresentableRoute {

    var info: RouteInfo {

        RouteInfo(

            route: self.places.map { .init(

                title: $0.name,
                coordinates: CLLocationCoordinate2D(

                    latitude: Double($0.coordinate.latitude),
                    longitude: Double($0.coordinate.longitude)))
            },
            tags: self.tags.map { $0.value },
            price: Self.price(from: metrics),
            distance: Self.distance(from: metrics)
        )
    }

    private static func price(from metrics: [RouteMetric]) -> String {

        "$\(Int(metrics.first(where: { $0.name == RouteMetric.price })?.value ?? 0))"
    }

    private static func distance(from metrics: [RouteMetric]) -> String {

        let measurement = Measurement(

            value: Double(metrics.first(where: { $0.name == RouteMetric.distance })?.value ?? 0),
            unit: UnitLength.meters

        ).converted(to: .kilometers)

        return "\(Int(measurement.value)) \(measurement.unit.symbol)"
    }
}
