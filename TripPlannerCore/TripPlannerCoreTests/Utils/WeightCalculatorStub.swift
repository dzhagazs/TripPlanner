//
//  WeightCalculatorStub.swift
//  TripPlannerCoreTests
//
//  Created by Alexandr Vasildzhagaz on 25.01.2024.
//

struct WeightCalculatorStub {

    enum WeightCalculatorStubError: Swift.Error, Equatable {

        case notFound
    }

    typealias Error = WeightCalculatorStubError

    let values: [String: Int]
    let `default`: Int?

    init(_ values: [((String, String), Int)], default: Int? = nil) {

        var transformed: [String: Int] = [:]
        values.forEach { transformed[Self.key(for: $0.0)] = $0.1 }

        self.values = transformed
        self.default = `default`
    }

    func weight(for connection: (String, String)) async throws -> Int {

        guard let value = values[Self.key(for: connection)] ?? self.default else { throw Error.notFound }

        return value
    }

    // MARK: Private

    private static let separator = "->"

    private static func key(for connection: (String, String)) -> String { "\(connection.0)\(separator)\(connection.1)" }
}
