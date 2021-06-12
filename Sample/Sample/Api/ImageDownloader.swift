//
//  ImageDownloader.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public protocol Downloader {
    func makeApiCall<R: ApiResponse>(for reqeust: ApiReqeust, caller: ApiCaller, response: @escaping (R)->Void) throws
}
