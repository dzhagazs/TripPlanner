//
//  ConnectionDecoder.swift
//  TripPlannerCore
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import Foundation

protocol ConnectionDecoder {

    func decode(_ data: Data) throws -> [Connection]
}
