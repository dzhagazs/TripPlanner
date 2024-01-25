//
//  RouteBuilderError.swift
//  TripPlannerCore
//
//  Created by Alexandr Vasildzhagaz on 25.01.2024.
//

enum RouteBuilderError: Swift.Error, Equatable {

    case toNotFound
    case fromNotFound
    case invalidWeight
}
