//
//  DownloadDelegate.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public protocol DownloadDelegate: class {
    func got<T>(_ data: T?, request: ApiReqeust)
}
