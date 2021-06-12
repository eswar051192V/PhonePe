//
//  ApiType.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public typealias KDictionary = [String: Any]
public typealias KListOfDictionary = [[String: Any]]

public enum ApiType: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}
