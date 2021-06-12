//
//  Utility.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public protocol CellViewModel {
    var cellIdentifier: String {get}
}

public protocol StandardCell {
    func set<T>(model: T)
}

public protocol CellDataSource: class {
    func section() -> Int
    func row(section: Int) -> Int
    func data<DATA>(forRow row: Int, onSection section: Int) -> DATA?
}

public protocol CellDelegate: class {
    func didSelect(forRow row: Int, onSection section: Int)
}

public protocol ViewModel: ViewModelDelegate {
    func set<T: ViewModelDelegate>(delegate: T?)
}

public protocol ViewModelDelegate: class {
    func updateUserInteface()
}

import UIKit

public protocol UILabelDefaultFormat: UIViewDefaultFormat {
    var text: String {get set}
    var textColor: UIColor? {get set}
    var font: UIFont? {get set}
}

public struct LabelDefaultFormat: UILabelDefaultFormat {
    public var backgroundColor: UIColor? = .clear
    
    public var text: String
    
    public var textColor: UIColor?
    
    public var font: UIFont?
}

extension UILabel {
    public func set(format: UILabelDefaultFormat?) {
        self.text = format?.text
        self.font = format?.font
        self.textColor = format?.textColor
        self.backgroundColor = format?.backgroundColor
    }
}

public protocol UIImageViewDefaultFormat: UIViewDefaultFormat {
    var image: UIImage? {get set}
    var tintColor: UIColor? {get set}
    var contentMode: UIView.ContentMode {get set}
}

public protocol UIViewDefaultFormat {
    var backgroundColor: UIColor? {get set}
}

extension UIImageView {
    public func set(format: UIImageViewDefaultFormat?) {
        self.image = format?.image
        self.tintColor = format?.tintColor
        self.contentMode = format?.contentMode ?? .scaleAspectFit
        self.backgroundColor = format?.backgroundColor
    }
}

extension UIView {
    public func set(format: UIViewDefaultFormat?) {
        self.backgroundColor = format?.backgroundColor
    }
}

public struct ImageViewDefaultFormat: UIImageViewDefaultFormat {
    public var backgroundColor: UIColor? = .clear
    
    public var image: UIImage?
    
    public var tintColor: UIColor?
    
    public var contentMode: UIView.ContentMode = .scaleAspectFit
}

public struct ViewDefaultFormat: UIViewDefaultFormat {
    public var backgroundColor: UIColor? = .clear
}

