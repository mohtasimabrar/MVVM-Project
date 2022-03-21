//
//  Box.swift
//  Test MVVM Project
//
//  Created by BS236 on 18/3/22.
//

import Foundation

final class Box<U, T> {
    
    typealias Listener = (U, T) -> Void
    var listener: Listener?
    
    var value: T
    var status: U
    
    init(_ status: U, _ value: T) {
        self.status = status
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
}
