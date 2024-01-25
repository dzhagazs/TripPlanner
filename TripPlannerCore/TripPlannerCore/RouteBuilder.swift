//
//  RouteBuilder.swift
//  TripPlannerCore
//
//  Created by Olexandr Vasildzhagaz on 25.01.2024.
//

protocol RouteBuilder {

    associatedtype Metric: Equatable, Comparable

    typealias Route = ([Place], Metric)
    typealias MetricProvider = (Connection) async throws -> Metric

    func build(_ connections: [Connection], metricProvider: MetricProvider) -> Route
}
