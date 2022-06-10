//
//  AssetLoadersStorage.swift
// 
//
//  Created by Anton Protko on 10.06.22.
//

import Foundation

public class AssetLoader {
    private class Loading {
        let asset: Asset
        let loader: Loader
        var observers: [AssetLoaderObserver]
        
        init(asset: Asset, loader: Loader, observer: AssetLoaderObserver) {
            self.asset = asset
            self.loader = loader
            self.observers = [observer]
        }
    }
        
    private var loadings = [Loading]()
    private let checksumStorage: AssetsChecksumStorage
    private let syncQueue = DispatchQueue(label: "AssetLoadersStorageQueue")
    private let remoteLoader: RemoteLoader.Type
    private let fileManager: FileManager
    private let workQueue: DispatchQueue
    
    public init(checksumStorage: AssetsChecksumStorage,
                remoteLoader: RemoteLoader.Type,
                fileManager: FileManager = .default,
                workQueue: DispatchQueue = .global()) {
        self.checksumStorage = checksumStorage
        self.remoteLoader = remoteLoader
        self.fileManager = fileManager
        self.workQueue = workQueue
    }
    
    public func loadAsset(_ asset: Asset, observer: AssetLoaderObserver) {
        syncQueue.async {
            if let loading = self.findLoading(for: asset) {
                loading.observers.append(observer)
            } else {
                let loader = Loader(asset: asset,
                                    remoteLoaderType: self.remoteLoader,
                                    checksumStorage: self.checksumStorage,
                                    fileManager: self.fileManager) { [unowned self] result in
                    self.syncQueue.async {
                        let loading = self.findLoading(for: asset)!
                        loading.observers.forEach { observer in
                            self.workQueue.async {
                                observer.assetWasLoaded(result)
                            }
                        }
                        self.loadings.removeAll { $0.asset == asset }
                    }
                }

                self.loadings.append(Loading(asset: asset, loader: loader, observer: observer))
                
                self.workQueue.async {
                    loader.load()
                }
            }
        }
    }
    
    private func findLoading(for asset: Asset) -> Loading? {
        return loadings.first { asset == $0.asset }
    }
}
