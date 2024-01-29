//
//  PanelItemView.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

import SwiftUI

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
