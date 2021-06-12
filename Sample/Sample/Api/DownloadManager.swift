//
//  DownloadManager.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public protocol DownloadManager {
    func clear()
    func download<T: ApiReqeust, R>(for request: T, callback: ((R) -> Void)? )
}
