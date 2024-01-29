//
//  SyncRunnerStub.swift
//  TripPlannerTests
//
//  Created by Oleksandr Vasildzhahaz on 29.01.2024.
//

@testable import TripPlanner

final class SyncRunnerStub: SyncRunner {

    func perform(_ action: () -> Void) { action() }
}
