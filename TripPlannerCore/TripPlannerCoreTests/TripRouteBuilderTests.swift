//
//  TripRouteBuilderTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 28.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class TripRouteBuilderTests: XCTestCase {

    typealias SUT = TripRouteBuilder
    typealias Error = RouteBuilderError

    func test_build_rethrowsBuilderError() {

        expectToThrow(Error.notFound) {

            _ = try await self.makeSUT().build(

                from: Self.anyPlace("a"),
                to: Self.anyPlace("b"),
                connections: []
            )
        }
    }

    func test_build_returnsCheapestAndShortestRoutesIfTheirPathsAreDifferent() {

        execute {

            let routes = try await self.makeSUT().build(

                from: Self.anyPlace("a"),
                to: Self.anyPlace("b"),
                connections: [

                    (self.anyConnection("a", to: "c"), self.anyMetadata(1, 2)),
                    (self.anyConnection("a", to: "d"), self.anyMetadata(2, 1)),
                    (self.anyConnection("d", to: "b"), self.anyMetadata()),
                    (self.anyConnection("c", to: "b"), self.anyMetadata()),
                ]
            )

            XCTAssertEqual(routes, [

                .init(

                    places: [

                        Self.anyPlace("a"),
                        Self.anyPlace("c"),
                        Self.anyPlace("b")

                    ], 
                    tags: [.cheapest],
                    metrics: [

                        .init(name: RouteMetric.price, value: 1),
                        .init(name: RouteMetric.distance, value: 2)
                    ]
                ),

                .init(

                    places: [

                        Self.anyPlace("a"),
                        Self.anyPlace("d"),
                        Self.anyPlace("b")

                    ],
                    tags: [.shortest],
                    metrics: [

                        .init(name: RouteMetric.price, value: 2),
                        .init(name: RouteMetric.distance, value: 1)
                    ]
                )
            ])
        }
    }

    func test_build_returnsOneRouteIfCheapestAndShortestAreEqual() {

        execute {

            let routes = try await self.makeSUT().build(

                from: Self.anyPlace("a"),
                to: Self.anyPlace("b"),
                connections: [

                    (self.anyConnection("a", to: "c"), self.anyMetadata(1, 2)),
                    (self.anyConnection("a", to: "d"), self.anyMetadata(2, 3)),
                    (self.anyConnection("d", to: "b"), self.anyMetadata()),
                    (self.anyConnection("c", to: "b"), self.anyMetadata()),
                ]
            )

            XCTAssertEqual(routes, [

                .init(

                    places: [

                        Self.anyPlace("a"),
                        Self.anyPlace("c"),
                        Self.anyPlace("b")

                    ],
                    tags: [.cheapest, .shortest],
                    metrics: [

                        .init(name: RouteMetric.price, value: 1),
                        .init(name: RouteMetric.distance, value: 2)
                    ]
                )
            ])
        }
    }

    // MARK: Private

    private func makeSUT() -> SUT {

        let sut = TripRouteBuilderImpl()

        trackMemoryLeak(for: sut)

        return sut
    }
}
