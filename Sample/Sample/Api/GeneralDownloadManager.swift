//
//  GeneralDownloadManager.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public class GeneralDownloadManager: DownloadManager {
    
    private var type: ApiCallerType
    private weak var delegate: DownloadDelegate?
    private var callbackData: [String: ((KDictionary?) -> Void)?] = [String: ((KDictionary?) -> Void)?]()
    private var queue: DispatchQueue = DispatchQueue(label: "GenDown")
    
    public init(delegate: DownloadDelegate?, type: ApiCallerType = .urlSession) {
        self.delegate = delegate
        self.type = type
    }
    
    public static var shared = GeneralDownloadManager(delegate: nil)
    
    private var coreStack: Stack<ApiReqeust> = Stack<ApiReqeust>()
    
    private lazy var callers: [String: ApiCaller] = {
        var dict = [String: ApiCaller]()
        if let call1: ApiCaller = DownloadApiCallerFactory.factory(for: self.type) {
            dict[call1.id] = call1
        }
        if let call1: ApiCaller = DownloadApiCallerFactory.factory(for: self.type) {
            dict[call1.id] = call1
        }
        if let call1: ApiCaller = DownloadApiCallerFactory.factory(for: self.type) {
            dict[call1.id] = call1
        }
        if let call1: ApiCaller = DownloadApiCallerFactory.factory(for: self.type) {
            dict[call1.id] = call1
        }
        if let call1: ApiCaller = DownloadApiCallerFactory.factory(for: self.type) {
            dict[call1.id] = call1
        }
        return dict
    }()
    
    public func clear() {
        self.coreStack.reset()
    }
    
    public func download<T: ApiReqeust, R>(for request: T, callback: ((R) -> Void)? ) {
        if let callback = callback as? ((KDictionary?) -> Void) {
            self.callbackData[request.id] = callback
        }
        for caller in self.callers {
            if !caller.value.inProgress {
                self.makeCall(apiRequest: request, caller: caller.value)
                return
            }
        }
        self.coreStack.push(request)
    }
    
    private func makeCall(apiRequest: ApiReqeust, caller: ApiCaller) {
        guard let imageDownloader: Downloader = GeneralDownloaderFactory.factory(for: self.type) else {
            return
        }
        do {
            try imageDownloader.makeApiCall(for: apiRequest, caller: caller) { [weak self] (response: GeneralApiResponse<KDictionary>) in
                if let image = response.result {
                    self?.queue.async {
                        self?.delegate?.got(image, request: response.request)
                        if let callback = self?.callbackData.removeValue(forKey: response.request.id) {
                            callback?(image)
                        }
                    }
                }
                self?.checkNextItemInStack(caller: caller)
            }
        } catch {
            
        }
        self.callers[caller.id] = caller
    }
    
    private func checkNextItemInStack(caller: ApiCaller) {
        guard let nextRequest = self.coreStack.pop() else {
            return
        }
        self.makeCall(apiRequest: nextRequest, caller: caller)
    }
    
}
