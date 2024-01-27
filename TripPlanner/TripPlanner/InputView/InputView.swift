//
//  InputView.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import SwiftUI

struct InputView: View {

    @Bindable var vm: InputViewModel
    let onEdit: (String) -> Void
    let onSelect: (String) -> Void

    var body: some View {

        VStack {

            TextField(vm.key, text: $vm.value)

                .padding()

            ZStack {

                List(vm.suggestions, id: \.self) { suggestion in

                    Text(suggestion)

                        .onTapGesture {onSelect(suggestion) }
                }

                .listStyle(.plain)
                .opacity(vm.loading ? 0 : 1)

                VStack {

                    ProgressView()

                        .padding()

                    Spacer()
                }

                .opacity(vm.loading ? 1 : 0)

            }
        }

        .onChange(of: vm.value) { withAnimation { onEdit(vm.value) } }
    }
}

#Preview {

    let vm = InputViewModel(

        key: "From",
        value: "",
        suggestions: ["London", "Tokyo"],
        loading: false
    )

    return InputView(vm: vm, onEdit: { _ in }, onSelect: { _ in })
}
