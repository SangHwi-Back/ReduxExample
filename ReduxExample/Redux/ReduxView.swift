//
//  View.swift
//  ReduxExample
//
//  Created by 백상휘 on 4/26/24.
//

import Foundation

protocol ReduxView {
    associatedtype R: ReduxReducer
    var reducer: R { get set }
    mutating func send(_ action: R.Actions) async
}

extension ReduxView {
    mutating func send(_ action: R.Actions) async {
        
    }
}
