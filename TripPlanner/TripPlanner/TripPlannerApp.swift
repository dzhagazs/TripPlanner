//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import SwiftUI
import TripPlannerCore

@main
struct TripPlannerApp: App {
    var body: some Scene {
        WindowGroup {
            TripView(places: [], route: nil)
        }
    }
}
