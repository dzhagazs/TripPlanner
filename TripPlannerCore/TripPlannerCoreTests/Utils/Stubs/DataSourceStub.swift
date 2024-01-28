//
//  DataSourceStub.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import Foundation

final class DataSourceStub: ConnectionDataSource {

    typealias Value = Result<Data, Error>

    // MARK: DataSource

    func load() async throws -> Data {

        try result.get()
    }

    init(result: Value) {

        self.result = result
    }

    // MARK: Private

    private let result: Value
}
