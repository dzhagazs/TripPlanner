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
    let routes: [RouteInfo]

    @Binding var selectedRoute: RouteInfo?

    var body: some View {

        VStack {

            Map {

                ForEach(places, id: \.self) { place in

                    Marker(place.title, coordinate: place.coordinates)
                }

                if let route = selectedRoute {

                    MapPolyline(coordinates: route.route.map { $0.coordinates })

                        .stroke(.blue, lineWidth: 10)
                }
            }

            RoutesListView(routes: routes, selectedRoute: $selectedRoute)

                .frame(height: routes.isEmpty ? 0 : 150)

        }
    }
}
