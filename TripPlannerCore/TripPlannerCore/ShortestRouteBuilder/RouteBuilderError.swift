//
//  RouteBuilderError.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 25.01.2024.
//

enum RouteBuilderError: Swift.Error, Equatable {

    case toNotFound
    case fromNotFound
    case invalidWeight
    case notFound
}
