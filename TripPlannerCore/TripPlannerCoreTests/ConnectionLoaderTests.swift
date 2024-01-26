//
//  ConnectionLoaderTests.swift
//  TripPlannerCoreTests
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

@testable import TripPlannerCore

import XCTest

final class ConnectionLoaderTests: XCTestCase {

    typealias SUT = ConnectionLoader
    typealias Error = TestError

    func test_load_forwardsConnections() {

        expectToLoad(

            [

                (anyConnection("a"), anyMetadata(1, 2)),
                (anyConnection("b"), anyMetadata(1, 2)),

            ],
            on: makeSUT(

                decoderResult: .success([

                    anyConnection("a"),
                    anyConnection("b")
                ]),
                providerResult: .success(anyMetadata(1, 2))
            )
        )
    }

    func test_load_forwardsDataSourceError() {

        expectToFail(

            Error.first,
            on: makeSUT(sourceResult: .failure(Error.first))
        )
    }

    // MARK: Private

    private func anyMetadata(_ price: Int, _ distance: Float) -> ConnectionMetadata {

        .init(price: price, approxDistance: distance)
    }

    private func anyConnection(_ from: String = "", to: String = "") -> Connection {

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

    private func expectToLoad(

        _ connections: [(Connection, ConnectionMetadata)],
        on sut: SUT,
        file: StaticString = #file,
        line: UInt = #line

    ) {

        execute(file: file, line: line) {

            let result = try await sut.load()

            XCTAssertEqual(connections.map { $0.0 }, result.map { $0.0 }, file: file, line: line)
            XCTAssertEqual(connections.map { $0.1 }, result.map { $0.1 }, file: file, line: line)
        }
    }

    private func expectToFail(

        _ error: Error,
        on sut: SUT,
        file: StaticString = #file,
        line: UInt = #line

    ) {

        expectToThrow(error, file: file, line: line) {

            _ = try await sut.load()
        }
    }

    private func makeSUT(

        sourceResult: DataSourceStub.Value = .success(Data()),
        decoderResult: ConnectionDecoderStub.Value = .success([]),
        providerResult: MetadataProviderStub.Value = .success(.init(price: 0, approxDistance: 0))

    ) -> SUT {

        let sut = ConnectionLoaderImpl(

            client: DataSourceStub(result: sourceResult),
            decoder: ConnectionDecoderStub(result: decoderResult),
            provider: MetadataProviderStub(result: providerResult)
        )

        trackMemoryLeak(for: sut)

        return sut
    }
}

enum TestError: Error, Equatable {

    case first
    case second
}

extension ConnectionMetadata: Equatable {

    public static func == (lhs: ConnectionMetadata, rhs: ConnectionMetadata) -> Bool {

        lhs.price == rhs.price && lhs.approxDistance == rhs.approxDistance
    }
}

extension Connection: Equatable {

    public static func == (lhs: Connection, rhs: Connection) -> Bool {

        lhs.from == rhs.from && lhs.to == rhs.to
    }
}
