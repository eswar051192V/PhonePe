//
//  Stack.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public protocol Stackable {
    associatedtype ItemType
    
    var count: Int {get}
    
    var isEmpty: Bool {get}
    
    mutating func push(_ item: ItemType)
    
    mutating func pop() -> ItemType?
    
    func peek() throws -> ItemType
    
    subscript(i: Int) -> ItemType { get }
    
    mutating func reset()
}

public struct Stack<T>: Stackable, Collection {
    
    public typealias ItemType = T
    
    public var startIndex: Int {
        return self.list.startIndex
    }
    
    public var endIndex: Int {
        return self.list.endIndex
    }
    
    public var count: Int {
        return self.list.count
    }
    
    public var isEmpty: Bool {
        return self.list.isEmpty
    }
    
    private var list: [T] = [T]()
    
    public init(list: [T] = [T]()) {
        self.list = list
    }
    
    public mutating func push(_ item: T) {
        self.list.append(item)
    }
    
    public mutating func pop() -> T? {
        return self.list.popLast()
    }
    
    public func peek() throws -> T {
        guard !self.isEmpty, let lastElement = self.list.last else {
            throw DefaultError.Empty(message: "Array is empty")
        }
        return lastElement
    }
    
    public subscript(i: Int) -> T {
        return self.list[i]
    }
    
    public func index(after i: Int) -> Int {
        return self.list.index(after: i)
    }
    
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator { curr.pop() }
    }
    
    public mutating func reset() {
        self.list = [T]()
    }
}
