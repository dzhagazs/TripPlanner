//
//  RouteListView.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

import SwiftUI

struct RoutesListView: View {

    let routes: [RouteInfo]

    @Binding var selectedRoute: RouteInfo?

    var body: some View {

        List(routes, id: \.self) { route in

            VStack(alignment: .leading) {

                Text(route.route.map { $0.title }.joined(separator: "->"))
                Text("price: \(route.price)")
                Text("distance: \(route.distance)")
                Text(route.tags.joined(separator: " "))
            }

            .onTapGesture { withAnimation { selectedRoute = route } }
            .fontWeight(route == selectedRoute ? .bold : .regular)
        }
    }
}
