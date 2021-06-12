//
//  GeneralApiResponse.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public struct GeneralApiResponse<T>: ApiResponse {
    public var request: ApiReqeust
    public var result: T?
    public var error: Error?
}
