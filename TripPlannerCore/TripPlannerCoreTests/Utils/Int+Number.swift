//
//  Int+Number.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhagaz on 25.01.2024.
//

@testable import TripPlannerCore

extension Int: Number {

    public static var upperBound: Self { .max }
    public static var zero: Self { 0 }
}

