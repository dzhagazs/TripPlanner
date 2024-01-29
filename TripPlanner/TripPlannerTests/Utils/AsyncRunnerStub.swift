//
//  AsyncRunnerStub.swift
//  TripPlannerTests
//
//  Created by Oleksandr Vasildzhahaz on 29.01.2024.
//

@testable import TripPlanner

import XCTest

final class AsyncRunnerStub: AsyncRunner {

    func perform(_ action: @escaping () async -> Void) {

        Task {

            await action()

            expectation?.fulfill()
        }
    }

    var expectation: XCTestExpectation?
}
