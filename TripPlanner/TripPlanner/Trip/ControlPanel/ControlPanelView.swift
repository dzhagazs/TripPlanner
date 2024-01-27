//
//  ControlPanelView.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

import SwiftUI

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
