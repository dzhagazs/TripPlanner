//
//  TripPlanModel.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

import Foundation

import TripPlannerCore

class TripPlanModel {

    let vm: TripPlanViewModel = .init()

    let fromPickerVM: InputViewModel = .init(key: "From")
    let toPickerVM: InputViewModel = .init(key: "To")

    init(

        planner: TripPlanner,
        asyncRunner: AsyncRunner,
        callbackRunner: SyncRunner

    ) {

        self.planner = planner
        self.asyncRunner = asyncRunner
        self.callbackRunner = callbackRunner
    }

    func load() {

        vm.loading = true
        asyncRunner.perform { [weak self] in

            guard let self = self else { return }

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
        refreshPickers()

        buildRouteIfPossible()
    }

    func selectTo(_ to: String) {

        guard let place = places?.first(where: { $0.name == to }) else {

            // TODO: Display error here
            return
        }

        try? planner.select(to: place)
        refreshPickers()

        buildRouteIfPossible()
    }

    func clear() {

        planner.clearSelection()
        fromPickerVM.clear()
        toPickerVM.clear()
        refreshPickers()
        vm.routes = []
        vm.selectedRoute = nil
    }

    // MARK: Private

    private func buildRouteIfPossible() {

        guard canBuildRoute() else { return }

        asyncRunner.perform { [weak self] in

            guard let self = self else { return }

            do {

                let routes = try await planner.build()
                configure(routes)

            } catch {

                print("Error building route: \(error).")
            }
        }
    }

    private func configure(_ places: [Place]) {

        callbackRunner.perform {

            self.places = places
            self.vm.loading = false
            self.vm.places = places.asAnnotations

            self.refreshPickerSuggestions()
            self.refreshPickers()
        }
    }

    private func configure(_ routes: [PresentableRoute]) {

        callbackRunner.perform {

            self.vm.routes = routes.map { $0.info }
            self.vm.selectedRoute = self.vm.routes.first
        }
    }

    private func canBuildRoute() -> Bool {

        planner.from != nil && planner.to != nil
    }

    private func refreshPickerSuggestions() {

        self.toPickerVM.suggestions = self.planner.toSuggestions(filter: "").map { $0.name }
        self.fromPickerVM.suggestions = self.planner.fromSuggestions(filter: "").map { $0.name }
    }

    private func refreshPickers() {

        vm.toValue = .init(value: planner.to?.name, placeholder: "To")
        vm.fromValue = .init(value: planner.from?.name, placeholder: "From")
    }

    private let planner: TripPlanner
    private let asyncRunner: AsyncRunner
    private let callbackRunner: SyncRunner
    private var places: [Place]?
}
