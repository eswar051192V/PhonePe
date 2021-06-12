//
//  ViewController.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import UIKit

class GameViewController: UIViewController, ViewModelDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public lazy var model: GViewModel = GameViewModel()
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var imageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.set(delegate: self)
        // Do any additional setup after loading the view.
    }

    func updateUserInteface() {
        self.imageView?.set(format: self.model.poster)
        self.collectionView?.reloadData()
    }
    
    func numberOfItemsInSection() -> Int {
        return self.model.section()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.row(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model: CollectionCellViewModel = self.model.data(row: indexPath.row, section: indexPath.section) else {
            return UICollectionViewCell()
        }
        
    }
    
    
}

public protocol GViewModel: ViewModel, CellDataSource, CellDelegate {
    
    var poster: UIImageViewDefaultFormat {get}
    func reset()
}

public class GameViewModel: GViewModel, GameUseCaseDelegate {
    public var poster: UIImageViewDefaultFormat {
        return ImageViewDefaultFormat(backgroundColor: .clear, image: self.image, tintColor: .none, contentMode: .scaleAspectFit)
    }
    
   
    private lazy var useCase: GameUseCase = CurrentGameUseCase(delegate: self)
    private weak var delegate: ViewModelDelegate?
    private var game: Game?
    private var imageDownloader: ImageDownloadUseCase?
    
    private var image: UIImage?
    private var selections: [CollectionCellViewModel] = [CollectionCellViewModel]()
    private var selectables: [CollectionCellViewModel] = [CollectionCellViewModel]()
    
    public func set<T>(delegate: T?) where T : ViewModelDelegate {
        self.delegate = delegate
        self.useCase.start()
    }
    
    public func updateUserInteface() {
        DispatchQueue.main.async {
            self.delegate?.updateUserInteface()
        }
    }
    
    public func section() -> Int {
        return self.game != nil ? 2 : 0
    }
    
    public func row(section: Int) -> Int {
        switch section {
        case 0:
            return self.selections.count
        default:
            return self.selectables.count
        }
    }
    
    public func data<DATA>(forRow row: Int, onSection section: Int) -> DATA? {
        switch section {
        case 0:
            return self.selections[row] as? DATA
        default:
            return self.selectables[row] as? DATA
        }
    }
    
    public func new(game: Game) {
        self.game = game
        self.image = nil
        self.selections = [CollectionCellViewModel]()
        self.selectables = self.game?.name.map { (value) -> CollectionCellViewModel in
            var str = String(value)
            return CollectionCellViewModel(text: str)
        } ?? [CollectionCellViewModel]()
    }
    
    private func makeImageCall() {
        let request = UrlSessionApiRequest(urlString: self.game?.imgUrl ?? "")
        self.imageDownloader = ImageDownloadUseCase(delegate: self, request: request)
        self.imageDownloader?.download()
    }

    public func didSelect(forRow row: Int, onSection section: Int) {
        switch section {
        case 0:
            return
        default:
            let selection = self.selectables[row]
            if selection.isSelected {
                
            }
        }
    }
    
    public func reset() {
        self.selections = []
        self.selectables = self.selectables.map { value -> CollectionCellViewModel in
            var value = value
            value.isSelected = false
            return value
        }
        self.updateUserInteface()
    }
    
}

public protocol GameUseCaseDelegate: class {
    func new(game: Game)
}

public protocol GameUseCase {
    func start()
    func next()
}

public class CurrentGameUseCase: GameUseCase {
    
    var isLoaded: Bool = false
    private weak var delegate: GameUseCaseDelegate?
    private var games: [Game] = [Game]()
    private var index: Int = 0
    
    public init(delegate: GameUseCaseDelegate?) {
        self.delegate = delegate
    }
    
    
    public func start() {
        let read = JsonFileReader(fileName: JsonFiles.file, type: "json")
        let list: [KDictionary] = read.read(type: [KDictionary]()) ?? [KDictionary]()
        let mapped = list.map { (value) -> Game in
            return Game(dict: value)
        }
    }
    
    public func next() {
        self.index += 1
        if self.index == self.games.count {
            self.index -= 1
        }
        
        self.delegate?.new(game: self.games[self.index])
    }
    
    
}

public class CollectionCell: UICollectionViewCell, StandardCell {
    
    @IBOutlet private var text: UILabel?
    private var model: CollectionCellVM?
    
    public func set<T>(model: T) {
        guard let mdoel = model as? CollectionCellVM else {
            return
        }
        self.model = mdoel
        self.set(format: self.model?.background)
        self.text?.set(format: self.model?.title)
    }
    
}

public protocol CollectionCellVM: CellViewModel {
    var title: UILabelDefaultFormat {get}
    var background: UIViewDefaultFormat {get}
}

public class CollectionCellViewModel: CollectionCellVM {
    
    public var background: UIViewDefaultFormat {
        return ViewDefaultFormat(backgroundColor: self.isAnswer ? .red : self.isSelected ? .black : .white) as! UILabelDefaultFormat
    }
    
    public var title: UILabelDefaultFormat {
        return LabelDefaultFormat(backgroundColor: .clear, text: self.text, textColor: self.isAnswer ? .black : self.isSelected ? .white : .darkText, font: .systemFont(ofSize: 16.0, weight: UIFont.Weight.heavy))
    }
    
    public var isSelected: Bool
    public var isAnswer: Bool
    
    private var text: String
    
    public var cellIdentifier: String = "cell"
    
    public init(text: String, isSelected: Bool = false, isAnswer: Bool = false) {
        self.text = text
        self.isAnswer = isAnswer
        self.isSelected = isSelected
    }
    
}

public struct Game {
    var imgUrl: String = ""
    var name: String = ""
    
    init(dict: KDictionary) {
        self.imgUrl = dict["imgUrl"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
    }
}

protocol FileReader {
    func read<T>(type: T) -> T?
}

class JsonFileReader: FileReader {

    var fileName: String
    var type: String
    
    init(fileName: String, type: String) {
        self.fileName = fileName
        self.type = type
    }
    
    func read<T>(type: T) -> T? {
        if let path = Bundle.main.path(forResource: self.fileName, ofType: self.type) {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? T {
                    return jsonResult
                  }
              } catch {
                   // handle error
              }
        }
        return nil
    }
    
}

struct JsonFiles {
    static let file = "file"
}
