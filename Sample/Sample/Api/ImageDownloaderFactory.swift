//
//  ImageDownloaderFactory.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public class ImageDownloaderFactory: Factory {
    public static func factory<T, R>(for item: T) -> R? {
        guard let item = item as? ApiCallerType else {
            return nil
        }
        switch item {
        case .urlSession:
            return UrlSessionImageDownloader() as? R
        default:
            return nil
        }
    }
}



public class GeneralDownloaderFactory: Factory {
    public static func factory<T, R>(for item: T) -> R? {
        guard let item = item as? ApiCallerType else {
            return nil
        }
        switch item {
        case .urlSession:
            return UrlSessionGeneralDownloader() as? R
        default:
            return nil
        }
    }
}
