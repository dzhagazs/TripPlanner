//
//  TripPlanModel.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

import Foundation
import CoreLocation.CLLocation

import TripPlannerCore

class TripPlanModel {

    let vm: TripPlanViewModel = .init()

    let fromPickerVM: InputViewModel = .init(key: "From")
    let toPickerVM: InputViewModel = .init(key: "To")

    init(

        planner: TripPlanner

    ) {

        self.planner = planner
    }

    func load() {

        vm.loading = true
        Task {

            do {

                let places = try await planner.loadPlaces()
                self.configure(places)

            } catch {

                print("Error loading places: \(error)")
            }
        }
    }

    func filterFrom(_ from: String) {

        fromPickerVM.suggestions = planner.fromSuggestions(filter: from).map { $0.name }
    }

    func filterTo(_ to: String) {

        toPickerVM.suggestions = planner.toSuggestions(filter: to).map { $0.name }
    }

    func selectFrom(_ from: String) {

        guard let place = places?.first(where: { $0.name == from }) else {

            // TODO: Display error here
            return
        }

        try? planner.select(from: place)
        vm.fromValue = .init(value: planner.from?.name ?? "", placeholder: "From")

        buildRouteIfPossible()
    }

    func selectTo(_ to: String) {

        guard let place = places?.first(where: { $0.name == to }) else {

            // TODO: Display error here
            return
        }

        try? planner.select(to: place)
        vm.toValue = .init(value: planner.to?.name ?? "", placeholder: "To")

        buildRouteIfPossible()
    }

    func clear() {

        planner.clearSelection()
        fromPickerVM.clear()
        toPickerVM.clear()
        vm.fromValue = .init(value: nil, placeholder: "From")
        vm.toValue = .init(value: nil, placeholder: "To")
        vm.route = []
    }

    // MARK: Private

    private func buildRouteIfPossible() {

        guard canBuildRoute() else { return }

        Task {

            do {

                let routes = try await planner.build()
                configure(routes)

            } catch {

                print("Error building route: \(error).")
            }
        }
    }

    private func configure(_ places: [Place]) {

        performOnMain {

            self.places = places
            self.vm.loading = false
            self.vm.places = places.map { .init(

                title: $0.name,
                coordinates: .init(

                    latitude: Double($0.coordinate.latitude),
                    longitude: Double($0.coordinate.longitude)
                ))
            }
        }
    }

    private func configure(_ routes: [PresentableRoute]) {

        performOnMain {

            self.vm.route = routes.first?.places.map { CLLocationCoordinate2D(latitude: Double($0.coordinate.latitude), longitude: Double($0.coordinate.longitude)) } ?? []
        }
    }

    private func canBuildRoute() -> Bool {

        planner.from != nil && planner.to != nil
    }

    private let planner: TripPlanner
    private var places: [Place]?
}
