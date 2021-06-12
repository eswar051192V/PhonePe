//
//  ImageDownloadApiCallerFactory.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public class ImageDownloadApiCallerFactory: Factory {
    public static func factory<T, R>(for item: T) -> R? {
        guard let item = item as? ApiCallerType else {
            return nil
        }
        switch item {
        case .urlSession:
            return UrlSessionApiCaller() as? R
        default:
            return nil
        }
    }
}
