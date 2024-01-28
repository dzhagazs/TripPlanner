//
//  Root.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

public func start() -> TripPlanner {

    TripPlannerImpl(

        loader: ConnectionLoaderFactory.create(),
        routeBuilder: TripRouteBuilderFactory.create()
    )
}
