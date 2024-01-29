//
//  HashablePlace.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 27.01.2024.
//

struct HashablePlace: Hashable {

    let name: String
    let coordinate: HashableCoordinate
}

extension HashablePlace {

    var original: Place { .init(name: name, coordinate: coordinate.original) }
}

extension Place {

    var hashable: HashablePlace { .init(name: name, coordinate: coordinate.hashable) }
}
