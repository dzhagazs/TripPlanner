//
//  MetadataProviderFactoryTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 30.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class MetadataProviderFactoryTests: XCTestCase {

    typealias SUT = MetadataProviderFactory

    func test_create_returnsCorrectImplementation() {

        XCTAssertTrue(SUT.create() is MetadataProviderImpl)
    }
}
