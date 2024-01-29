//
//  MainThreadCheck.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

import Foundation

func performOnMain(_ action: () -> Void) {

    if Thread.isMainThread {

        action()

    } else {

        DispatchQueue.main.asyncAndWait {

            action()
        }
    }
}
