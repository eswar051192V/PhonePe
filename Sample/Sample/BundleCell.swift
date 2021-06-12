//
//  BundleCell.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation
import UIKit

public class BundleCell: UITableViewCell, StandardCell, ViewModelDelegate {
    
    
    @IBOutlet private var title: UILabel?
    @IBOutlet private var poster: UILabel?
    @IBOutlet private var desc: UILabel?
    private var model: BundleCellViewModel?
    
    public func set<T>(model: T) {
        guard let model = model as? BundleCellViewModel else {
            return
        }
        self.model = model
        self.model?.set(delegate: self)
    }
    
    public func updateUserInteface() {
        self.title?.set(format: self.model?.title)
        self.poster?.set(format: self.model?.poster)
        self.desc?.set(format: self.model?.desc)
        self.layoutIfNeeded()
        self.superview?.layoutIfNeeded()
    }
}

public protocol BundleCellViewModel: CellViewModel, ViewModel {
    var title: UILabelDefaultFormat {get}
    var poster: UIImageViewDefaultFormat {get}
    var desc: UILabelDefaultFormat {get}
}

public class MainBundleCellViewModel: BundleCellViewModel {
    public var title: UILabelDefaultFormat {
        return LabelDefaultFormat(backgroundColor: .clear, text: "Title", textColor: .darkText, font: .systemFont(ofSize: 16.0, weight: UIFont.Weight.heavy))
    }
    
    private var image: UIImage?
    
    public var poster: UIImageViewDefaultFormat {
        return ImageViewDefaultFormat(backgroundColor: .clear, image: self.image, tintColor: .none, contentMode: .scaleAspectFit)
    }
    
    public var desc: UILabelDefaultFormat {
        return LabelDefaultFormat(backgroundColor: .clear, text: "Desc", textColor: .darkText, font: .systemFont(ofSize: 12.0))
    }
    
    public var cellIdentifier: String = "bundleCell"
    
    private weak var delegate: ViewModelDelegate?
    
    
    public func set<T>(delegate: T?) where T : ViewModelDelegate {
        self.delegate = delegate as? ViewModelDelegate
        self.updateUserInteface()
        self.loadImageView()
    }
    
    public func updateUserInteface() {
        DispatchQueue.main.async {
            self.delegate?.updateUserInteface()
        }
    }
    
    private func loadImageView() {
        
    }
}

extension MainBundleCellViewModel: ImageDownloadUseCaseDelegate {
    public func image(image: UIImage?) {
        self.image = image
        self.updateUserInteface()
    }
}

public protocol ImageDownloadUseCaseDelegate: class {
    func image(image: UIImage?)
}

public protocol DownloadUseCase {
    func download()
}

public class ImageDownloadUseCase: DownloadUseCase {
    private weak var delegate: ImageDownloadUseCaseDelegate?
    public init(delegate: ImageDownloadUseCaseDelegate?, request: UrlSessionApiRequest) {
        self.delegate = delegate
        self.request = request
    }
    private var request: UrlSessionApiRequest
    //Model
    
    public func download() {
        ImageDownloadManager.shared.download(for: self.request) { [weak self] (response: ImageDownloaderResponse) in
            if let image = response.image, response.request.id == self?.request.id ?? "sample" {
                self?.delegate?.image(image: image)
            }
        }
    }
}
