//
//  InputViewModel.swift
//  TripPlanner
//
//  Created by Oleksandr Vasildzhahaz on 26.01.2024.
//

import Observation

@Observable class InputViewModel {

    let key: String
    var value: String
    var suggestions: [String]
    var loading: Bool

    convenience init(key: String) {

        self.init(key: key, value: "", suggestions: [], loading: false)
    }

    init(

        key: String,
        value: String,
        suggestions: [String],
        loading: Bool

    ) {

        self.key = key
        self.value = value
        self.suggestions = suggestions
        self.loading = loading
    }
}
