//
//  UrlSessionApiResponse.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public struct UrlSessionApiResponse: ApiResponse {
    public var request: ApiReqeust
    public var data: Data?
    public var error: Error?
    
    public init(request: ApiReqeust, data: Data?, error: Error?) {
        self.request = request
        self.data = data
        self.error = error
    }
}
