//
//  URLSession+Extension.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import Foundation

extension URLSession: ConnectionDataSource {

    func load() async throws -> Data {

        try await withCheckedThrowingContinuation { continuation in

            dataTask(with: Definitions.sourceURL) { data, response, error in

                guard let data = data else {

                    continuation.resume(throwing: error ?? SourceError.notFound)

                    return
                }

                continuation.resume(returning: data)

            }.resume()
        }
    }
}

enum SourceError: Swift.Error {

    case notFound
}
