//
//  ImageCache.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public protocol FileCache {
    static func cache<T>(_ data: T?, with key: String)
    static func fetch<T>(key: String) -> T?
}

import UIKit

public class ImageFileCache: FileCache {
    public static func fetch<T>(key: String) -> T? {
        let fileManager = FileManager.default
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(key)
        // Here using getDirectoryPath method to get the Directory path
        if fileManager.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path) as? T
        } else {
            print("No Image available")
            return UIImage.init(named: "placeholder") as? T
        }
    }
    
    public static func cache<T>(_ data: T?, with key: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = key
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        var fileData: Data?
        if let image = data as? UIImage {
            fileData = image.jpegData(compressionQuality: 1.0)
        } else if let data = data as? Data {
            fileData = data
        }
        
        if let file = fileData, !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try file.write(to: fileURL)
                print("file saved \(fileURL.absoluteString)")
            } catch {
                print("error saving file:", error)
            }
        }
    }
}
