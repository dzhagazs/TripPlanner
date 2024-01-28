//
//  RouteInfo.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

struct RouteInfo: Hashable {

    let route: [PlaceAnnotation]
    let tags: [String]
    let price: String
    let distance: String
}
