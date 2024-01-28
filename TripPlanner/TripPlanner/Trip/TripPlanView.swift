//
//  TripPlanView.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import SwiftUI

struct TripPlanView: View {

    @Bindable var vm: TripPlanViewModel

    let onClear: () -> Void

    let fromSource: () -> (InputViewModel, ((String) -> Void), ((String) -> Void))
    let toSource: () -> (InputViewModel, ((String) -> Void), ((String) -> Void))

    var body: some View {

        NavigationStack {

            VStack {

                RouteView(

                    places: vm.places,
                    routes: vm.routes,
                    selectedRoute: $vm.selectedRoute
                )

                .overlay {

                    ProgressView()

                        .opacity(vm.loading ? 1 : 0)
                }

                ControlPanelView(

                    onClear: onClear,
                    fromValue: $vm.fromValue,
                    toValue: $vm.toValue
                )

                .padding()
            }

            .navigationDestination(for: PanelItemValue.self) { panelItem in

                let panelValues = panelItem == vm.fromValue ? fromSource() : toSource()

                InputView(vm: panelValues.0, onEdit: panelValues.1, onSelect: panelValues.2)
            }
        }
    }
}

#Preview {

    TripPlanView(

        vm: .init(),
        onClear: {},
        fromSource: { (InputViewModel(key: "From"), { _ in }, { _ in }) },
        toSource: { (InputViewModel(key: "To"), { _ in }, { _ in }) }
    )
}
