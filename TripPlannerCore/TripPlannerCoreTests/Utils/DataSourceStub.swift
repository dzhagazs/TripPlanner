//
//  DataSourceStub.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import Foundation

final class DataSourceStub: ConnectionDataSource {

    // MARK: DataSource

    func load() async throws -> Data {

        try result.get()
    }

    init(result: Result<Data, Error>) {

        self.result = result
    }

    // MARK: Private

    private let result: Result<Data, Error>
}
