//
//  Sequence+Extension.swift
//  TripPlannerCore
//
//  Created by Olexandr Vasildzhahaz on 25.01.2024.
//

extension Sequence {

    func asyncForEach(

        _ operation: (Element) async throws -> Void

    ) async rethrows {

        for element in self {

            try await operation(element)
        }
    }
}
