//
//  Loader.swift
// 
//
//  Created by Anton Protko on 10.06.22.
//

import Foundation

class Loader {
    private let asset: Asset
    private let remoteLoaderType: RemoteLoader.Type
    private let checksumStorage: AssetsChecksumStorage
    private let fileManager: FileManager
    private let completion: (Result<URL, Error>) -> Void
        
    private var remoteLoader: RemoteLoader?
    
    init(asset: Asset,
         remoteLoaderType: RemoteLoader.Type,
         checksumStorage: AssetsChecksumStorage,
         fileManager: FileManager,
         completion: @escaping (Result<URL, Error>) -> Void) {
        self.asset = asset
        self.remoteLoaderType = remoteLoaderType
        self.checksumStorage = checksumStorage
        self.fileManager = fileManager
        self.completion = completion
    }
    
    func load() {
        if let builtInUrl = asset.builtInUrl, FileManager.default.fileExists(atPath: builtInUrl.path) {
            completion(.success(builtInUrl))
            return
        }
        
        guard
            let remoteUrl = asset.remoteUrl,
            let downloadedUrl = asset.downloadedUrl
        else {
            completion(.failure(AssetError.illegalAsset))
            return
        }
        
        let valid: Bool
        do {
            valid = try checksumStorage.isAssetChecksumValid(asset)
        } catch {
            completion(.failure(AssetError.storage(error: error)))
            return
        }
        
        if FileManager.default.fileExists(atPath: downloadedUrl.path) && valid {
            completion(.success(downloadedUrl))
            return
        }
        
        self.remoteLoader = remoteLoaderType.init(url: remoteUrl) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.completion(.failure(AssetError.network(error: error)))
            case .success(let data):
                do {
                    try self.saveRemoteData(data, downloadedUrl: downloadedUrl)
                } catch {
                    self.completion(.failure(AssetError.file(error: error)))
                    return
                }
                
                do {
                    try self.checksumStorage.updateAssetChecksum(self.asset)
                    self.completion(.success(downloadedUrl))
                } catch {
                    self.completion(.failure(AssetError.storage(error: error)))
                }
            }
        }
    }
    
    private func saveRemoteData(_ data: RemoteLoaderData, downloadedUrl: URL) throws {
        switch data {
        case .url(let url):
            try fileManager.copyItem(at: url, to: downloadedUrl)
        case .data(let data):
            try fileManager.createDirectory(at: downloadedUrl.deletingLastPathComponent(),
                                            withIntermediateDirectories: true,
                                            attributes: nil)
            try data.write(to: downloadedUrl)
        }
    }
}

