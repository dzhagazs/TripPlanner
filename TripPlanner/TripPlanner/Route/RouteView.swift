//
//  RouteView.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import SwiftUI
import MapKit

struct RouteView: View {

    let places: [PlaceAnnotation]
    let route: [CLLocationCoordinate2D]?

    var body: some View {

        Map {

            ForEach(places, id: \.self) { place in

                Marker(place.title, coordinate: place.coordinates)
            }

            if let route = route {

                MapPolyline(coordinates: route)

                    .stroke(.blue, lineWidth: 10)
            }
        }
    }
}

#Preview {

    RouteView(places: [

        .init(

            title: "London",
            coordinates: .init(latitude: 51.5285582, longitude: -0.241681)
        ),
        .init(

            title: "Lyon",
            coordinates: .init(latitude: 45.743061, longitude: 4.869658)
        ),
        .init(

            title: "Kharkiv",
            coordinates: .init(latitude: 49.955091, longitude: 36.337248)
        ),
        .init(

            title: "Dubai",
            coordinates: .init(latitude: 25.160947, longitude: 55.297016)
        ),
        .init(

            title: "Tokyo",
            coordinates: .init(latitude: 35.652832, longitude: 139.839478)
        ),
    ], route: [

        .init(latitude: 51.5285582, longitude: -0.241681),
        .init(latitude: 45.743061, longitude: 4.869658),
        .init(latitude: 49.955091, longitude: 36.337248),
        .init(latitude: 25.160947, longitude: 55.297016),
        .init(latitude: 35.652832, longitude: 139.839478)
    ])
}
