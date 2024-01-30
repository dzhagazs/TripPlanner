//
//  ConnectionDecoderFactory.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 30.01.2024.
//

final class ConnectionDecoderFactory {

    static func create() -> ConnectionDecoder {

        ConnectionDecoderImpl()
    }
}
