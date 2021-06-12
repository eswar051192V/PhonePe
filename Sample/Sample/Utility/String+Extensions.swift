//
//  String+Extensions.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

extension String {
    public var serverUrl: URL? {
        return URL(string: self)
    }
}
