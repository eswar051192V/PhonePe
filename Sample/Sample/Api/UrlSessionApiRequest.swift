//
//  UrlSessionApiRequest.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public struct UrlSessionApiRequest: ApiReqeust {
    public var id: String
    public var urlString: String
    public var type: ApiType
    public var requestHeader: KDictionary
    public var requestBody: KDictionary
    public var timeout: TimeInterval
    public var cachePolicy: URLRequest.CachePolicy
    
    public func urlRequest() throws -> URLRequest? {
        guard let url = self.urlString.serverUrl else {
            throw DefaultError.Empty(message: "Improper URL \(self.urlString)")
        }
        var request = URLRequest(url: url, cachePolicy: self.cachePolicy, timeoutInterval: self.timeout)
        if !self.requestHeader.isEmpty, let header = self.requestHeader as? [String: String]  {
            request.allHTTPHeaderFields = header
        }
        
        request.networkServiceType = .default
        request.allowsCellularAccess = true
        request.allowsConstrainedNetworkAccess = true
        request.allowsExpensiveNetworkAccess = true
        
        return request
    }
    
    public init(id: String = UUID().uuidString, urlString: String, type: ApiType = .post, requestHeader: KDictionary = KDictionary(), requestBody: KDictionary = KDictionary(), timeout: TimeInterval = 1000, cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) {
        self.id = id
        self.urlString = urlString
        self.type = type
        self.requestBody = requestBody
        self.requestHeader = requestHeader
        self.timeout = timeout
        self.cachePolicy = cachePolicy
    }
}
