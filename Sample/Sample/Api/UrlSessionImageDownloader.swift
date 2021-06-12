//
//  UrlSessionImageDownloader.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation
import UIKit

public class UrlSessionImageDownloader: Downloader {
    public func makeApiCall<R: ApiResponse>(for reqeust: ApiReqeust, caller: ApiCaller, response: @escaping (R)->Void) throws {
        guard let request = reqeust as? UrlSessionApiRequest else {
            let respnse = ImageDownloaderResponse(request: reqeust, image: nil, error: DefaultError.Empty(message: "Improper format"))
            response(respnse as! R)
            return
        }
        
        if let image: UIImage = ImageFileCache.fetch(key: request.urlString.keyOfUrl) {
            let resp = ImageDownloaderResponse(request: reqeust, image: image, error: nil)
            response(resp as! R)
            return
        }
        
        try caller.makeTheCall(request, completion: { (respnse: UrlSessionApiResponse) in
            var resp = ImageDownloaderResponse(request: reqeust, image: nil, error: nil)
            if let data = respnse.data {
                resp.image = UIImage(data: data)
                ImageFileCache.cache(resp.image, with: request.urlString.keyOfUrl)
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

extension String {
    var keyOfUrl: String {
        return (self as NSString).components(separatedBy: "/").last ?? ""
    }
}
