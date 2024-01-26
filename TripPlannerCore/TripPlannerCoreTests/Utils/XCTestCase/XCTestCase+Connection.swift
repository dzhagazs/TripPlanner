//
//  XCTestCase+Connection.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

extension XCTestCase {

    func anyConnection(_ from: String = "", to: String = "") -> Connection {

        .init(

            from: .init(

                name: from,
                coordinate: .zero
            ),
            to: .init(

                name: to,
                coordinate: .zero
            ))
    }
}
