//
//  ConnectionLoaderFactory.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

import Foundation

final class ConnectionLoaderFactory {

    static func create() -> ConnectionLoader {

        ConnectionLoaderImpl(

            client: URLSession.shared,
            decoder: ConnectionDecoderImpl(),
            provider: MetadataProviderImpl(distanceCalculator: DistanceCalculator.distance(from:to:))
        )
    }
}
