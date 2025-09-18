//
//  ThreadSafeList.swift
//  LokiAgent
// 
//  Created by: tomieq on 18/09/2025
//


import Foundation
import Dispatch

public class ThreadSafeList<V> {
    private let queue = DispatchQueue(label: "com.dispatchBarrier.\(UUID())", attributes: .concurrent)
    private var list: [V] = []
    
    public init() {}
    
    public var elements: [V] {
        get {
            queue.sync {
                list
            }
        }
    }
    
    public subscript(index: Int) -> V {
        get {
            queue.sync {
                list[index]
            }
        }
        set(newValue) {
            queue.sync(flags: .barrier) {
                self.list[index] = newValue
            }
        }
    }
    
    public var count: Int {
        queue.sync {
            list.count
        }
    }
    
    public func append(_ element: V) {
        queue.sync(flags: .barrier) {
            self.list.append(element)
        }
    }
    
    public func append(_ elements: [V]) {
        queue.sync(flags: .barrier) {
            self.list.append(contentsOf: elements)
        }
    }
    
    public func remove(_ elements: [V]) where V: Equatable {
        queue.sync(flags: .barrier) {
            self.list.removeAll{ elements.contains($0) }
        }
    }
    
    public func action(_ job: ([V]) -> [V]) {
        queue.sync(flags: .barrier) {
            self.list = job(self.list)
        }
    }
}
