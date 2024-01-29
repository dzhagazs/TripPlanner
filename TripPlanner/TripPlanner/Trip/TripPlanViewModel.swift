//
//  TripPlanViewModel.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

import Observation
import CoreLocation.CLLocation

@Observable class TripPlanViewModel {

    var places: [PlaceAnnotation] = []
    var routes: [RouteInfo] = []
    var selectedRoute: RouteInfo?
    var loading: Bool = false

    var fromValue: PanelItemValue = .init(value: nil, placeholder: "From")
    var toValue: PanelItemValue = .init(value: nil, placeholder: "To")
}
