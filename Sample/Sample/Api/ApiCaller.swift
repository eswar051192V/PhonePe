//
//  ApiCaller.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public protocol ApiCaller {
    var id: String {get}
    var inProgress: Bool {get set}
    
    func makeTheCall<Request: ApiReqeust, Response: ApiResponse>(_ reqeust: Request, completion: @escaping (Response) -> Void) throws
}
