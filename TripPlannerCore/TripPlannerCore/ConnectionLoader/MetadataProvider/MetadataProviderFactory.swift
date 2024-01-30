//
//  MetadataProviderFactory.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

import Foundation

final class MetadataProviderFactory {

    static func create() -> MetadataProvider {

        MetadataProviderImpl(distanceCalculator: DistanceCalculator.distance(from:to:))
    }
}
