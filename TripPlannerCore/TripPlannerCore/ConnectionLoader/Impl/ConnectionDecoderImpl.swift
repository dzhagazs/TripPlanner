//
//  ConnectionDecoderImpl.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import Foundation

final class ConnectionDecoderImpl: ConnectionDecoder {

    // MARK: ConnectionDecoder

    func decode(_ data: Data) throws -> [Connection] {

        try JSONDecoder().decode(CodableConnections.self, from: data).connections.map {

            .init(

                from: .init(

                    name: $0.from,
                    coordinate: .init(

                        latitude: $0.coordinates.from.lat,
                        longitude: $0.coordinates.from.lon
                    )
                ),
                to: .init(

                    name: $0.to,
                    coordinate: .init(

                        latitude: $0.coordinates.to.lat,
                        longitude: $0.coordinates.to.lon
                    )
                )
            )
        }
    }

    // MARK: Private

    private struct CodableConnections: Codable {

        let connections: [CodableConnection]
    }

    private struct CodableConnection: Codable {

        let from: String
        let to: String
        let price: Int
        let coordinates: CodableCoordinates
    }

    private struct CodableCoordinates: Codable {

        let from: CodableCoordinate
        let to: CodableCoordinate
    }

    private struct CodableCoordinate: Codable {

        let lat: Float
        let lon: Float
    }
}
