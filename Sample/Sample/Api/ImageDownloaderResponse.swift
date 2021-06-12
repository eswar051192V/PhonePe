//
//  ImageDownloaderResponse.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation
import UIKit

public struct ImageDownloaderResponse: ApiResponse {
    public var request: ApiReqeust
    
    public var image: UIImage?
    
    public var error: Error?
}
