//
//  HashableCoordinate.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

struct HashableCoordinate: Hashable {

    let latitude: Float
    let longitude: Float
}

extension HashableCoordinate {

    var original: Coordinate { .init(latitude: latitude, longitude: longitude) }
}

extension Coordinate {

    var hashable: HashableCoordinate { .init(latitude: latitude, longitude: longitude) }
}
