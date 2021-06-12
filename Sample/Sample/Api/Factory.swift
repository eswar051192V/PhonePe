//
//  Factory.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public protocol Factory {
    static func factory<T, R>(for item: T) -> R?
}
