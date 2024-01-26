//
//  MetadataProvider.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

protocol MetadataProvider {

    func metadata(for connection: Connection) async throws -> ConnectionMetadata
}
