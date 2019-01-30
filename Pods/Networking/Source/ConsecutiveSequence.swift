//
//  ConsecutiveSequence.swift
//  Networking
//
//  Created by Umut BOZ on 14/03/2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation
public struct ConsecutiveSequence<T: IteratorProtocol>: IteratorProtocol, Sequence {
    private var base: T
    private var index: Int
    private var previous: T.Element?
    
    init(_ base: T) {
        self.base = base
        self.index = 0
    }
    
    public typealias Element = (T.Element, T.Element)
    
    public mutating func next() -> Element? {
        guard let first = previous ?? base.next(), let second = base.next() else {
            return nil
        }
        
        previous = second
        
        return (first, second)
    }
}
extension Sequence {
    public func makeConsecutiveIterator() -> ConsecutiveSequence<Self.Iterator> {
        return ConsecutiveSequence(self.makeIterator())
    }
}
