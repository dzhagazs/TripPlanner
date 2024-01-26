//
//  ConnectionDataSource.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import Foundation

protocol ConnectionDataSource {

    func load() async throws -> Data
}
