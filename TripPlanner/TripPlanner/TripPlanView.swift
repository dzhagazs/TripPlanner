//
//  TripPlanView.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import SwiftUI
import CoreLocation.CLLocation

@Observable class TripPlanViewModel {

    var places: [PlaceAnnotation] = []
    var route: [CLLocationCoordinate2D] = []
    var loading: Bool = false
    var price: String = ""

    var fromValue: PanelItemValue = .init(value: nil, placeholder: "From")
    var toValue: PanelItemValue = .init(value: nil, placeholder: "To")
}

struct TripPlanView: View {

    @Bindable var vm: TripPlanViewModel

    let onClear: () -> Void

    let fromSource: () -> (InputViewModel, ((String) -> Void), ((String) -> Void))
    let toSource: () -> (InputViewModel, ((String) -> Void), ((String) -> Void))

    var body: some View {

        NavigationStack {

            VStack {

                RouteView(places: vm.places, route: vm.route)

                    .overlay {

                        ProgressView()

                            .opacity(vm.loading ? 1 : 0)
                    }

                ControlPanelView(

                    onClear: onClear,
                    price: $vm.price,
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

struct PanelItemValue: Hashable {

    let value: String?
    let placeholder: String
}

struct PanelItemView: View {

    @Binding var value: PanelItemValue

    var body: some View {

        NavigationLink(value: value) {

            HStack {

                Text(value.value ?? value.placeholder)

                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))

                Spacer()
            }

                .opacity(value.value == nil ? 0.5 : 1)
                .background(

                    RoundedRectangle(cornerSize: .init(width: 10, height: 10))

                        .stroke(style: .init(lineWidth: 2))
                        .foregroundStyle(.blue.opacity(0.2))
                )
        }
    }
}

struct ControlPanelView: View {

    let onClear: () -> Void

    @Binding var price: String
    @Binding var fromValue: PanelItemValue
    @Binding var toValue: PanelItemValue

    var body: some View {

        VStack {

            HStack {

                Spacer()

                Text(price)

                Spacer()

                Button(action: onClear, label: {

                    Image(systemName: "xmark.circle")

                        .resizable()
                })

                .frame(width: 30, height: 30)
            }

            PanelItemView(value: $fromValue)

            PanelItemView(value: $toValue)
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
