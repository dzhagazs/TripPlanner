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

    let tripModel = TripPlanModel(

        planner: start(),
        asyncRunner: AsyncRunnerImpl(),
        callbackRunner: MainQueueRunner()
    )

    var body: some Scene {

        WindowGroup {

            TripPlanView(

                vm: tripModel.vm,
                onClear: tripModel.clear,
                fromSource: { (tripModel.fromPickerVM, tripModel.filterFrom, tripModel.selectFrom) },
                toSource: { (tripModel.toPickerVM, tripModel.filterTo, tripModel.selectTo) }
            )

            .onAppear(perform: tripModel.load)
        }
    }
}
