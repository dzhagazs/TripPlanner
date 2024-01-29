//
//  AsyncRunnerStub.swift
//  TripPlannerTests
//
//  Created by Oleksandr Vasildzhahaz on 29.01.2024.
//

@testable import TripPlanner

import XCTest

final class AsyncRunnerStub: AsyncRunner {

    private(set) var calls: Int = 0

    func perform(_ action: @escaping () async -> Void) {

        calls += 1

        Task {

            await action()

            expectation?.fulfill()
        }
    }

    var expectation: XCTestExpectation?
}
