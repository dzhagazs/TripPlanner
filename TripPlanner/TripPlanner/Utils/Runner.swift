//
//  Runner.swift
//  TripPlanner
//
//  Created by Alexandr Vasildzhagaz on 29.01.2024.
//

import Foundation

protocol AsyncRunner {

    func perform(_ action: @escaping () async -> Void)
}

protocol SyncRunner {

    func perform(_ action: () -> Void)
}

final class AsyncRunnerImpl: AsyncRunner {

    func perform(_ action: @escaping () async -> Void) {

        Task { await action() }
    }
}

final class MainQueueRunner: SyncRunner {

    func perform(_ action: () -> Void) {

        performOnMain(action)
    }
}

extension DispatchQueue: AsyncRunner  {

    func perform(_ action: @escaping () async -> Void) {

        Task { await action() }
    }
}
