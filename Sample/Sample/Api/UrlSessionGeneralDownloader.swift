//
//  UrlSessionGeneralDownloader.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public class UrlSessionGeneralDownloader: Downloader {
    public func makeApiCall<R: ApiResponse>(for reqeust: ApiReqeust, caller: ApiCaller, response: @escaping (R)->Void) throws {
        guard let request = reqeust as? UrlSessionApiRequest else {
            let respnse = GeneralApiResponse<KDictionary>(request: reqeust, result: nil, error: DefaultError.Empty(message: "Improper format"))
            response(respnse as! R)
            return
        }
        try caller.makeTheCall(request, completion: { (respnse: UrlSessionApiResponse) in
            var resp = GeneralApiResponse<KDictionary>(request: reqeust, result: nil, error: nil)
            if let data = respnse.data,
               let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) {
                resp.result = jsonResult as? KDictionary ?? KDictionary()
            } else {
                if let error = respnse.error {
                    resp.error = error
                } else {
                    resp.error = DefaultError.Empty(message: "Unknown error")
                }
            }
            response(resp as! R)
        })
    }
}
