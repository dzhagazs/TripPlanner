//
//  Array+Extension.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

@testable import TripPlannerCore

extension Array where Element == Connection {

    var uniquePlaces: [Place] {

        var places = Set<HashablePlace>()

        self.forEach { connection in

            places.insert(connection.from.hashable)
            places.insert(connection.to.hashable)
        }

        return places.map { $0.original }.sorted(by: { $0.name < $1.name })

    }
}
