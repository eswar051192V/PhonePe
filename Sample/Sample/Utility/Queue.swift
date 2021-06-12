//
//  Queue.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public protocol Queueable {
    associatedtype ItemType
    
    var count: Int {get}
    
    var isEmpty: Bool {get}
    
    mutating func enqueue(_ item: ItemType)
    
    mutating func dequeue() -> ItemType?
    
    func peek() throws -> ItemType
    
    subscript(i: Int) -> ItemType { get }
    
    mutating func reset()
}

public struct Queue<T>: Queueable, Collection {
    
    public typealias ItemType = T
    
    public var startIndex: Int {
        return self.list.startIndex
    }
    
    public var endIndex: Int {
        return self.list.endIndex
    }

    private var list: [T] = [T]()
    
    public mutating func enqueue(_ item: T) {
        self.list.append(item)
    }
    
    public mutating func dequeue() -> T? {
        guard !self.isEmpty, let first = self.list.first else {
            return nil
        }
        self.list.remove(at: 0)
        return first
    }
    
    public func peek() throws -> T {
        guard !self.isEmpty, let first = self.list.first else {
            throw DefaultError.Empty(message: "Array is empty")
        }
        return first
    }
    
    public subscript(i: Int) -> T {
        return self.list[i]
    }
    
    public func index(after i: Int) -> Int {
        return self.list.index(after: i)
    }
    
    public mutating func reset() {
        self.list = [T]()
    }
}
