//
//  AssetLoaderObserver.swift
// 
//
//  Created by Anton Protko on 10.06.22.
//

import Foundation

public protocol AssetLoaderObserver: AnyObject {
    func assetWasLoaded(_ result: Result<URL, Error>)
}

public protocol BlockAssetLoaderObserver: AssetLoaderObserver {
    associatedtype ResultType
    
    var completion: (Result<ResultType, Error>) -> Void { get }    
    func convert(url: URL) throws -> ResultType
}

extension BlockAssetLoaderObserver {
    public func assetWasLoaded(_ result: Result<URL, Error>) {        
        do {
            let value = try convert(url: result.get())
            completion(.success(value))
        } catch {
            completion(.failure(error))
        }
    }
}
