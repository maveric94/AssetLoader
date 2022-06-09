//
//  DataAssetObserver.swift
// 
//
//  Created by Anton Protko on 10.06.22.
//

import Foundation

public class DataAssetObserver: BlockAssetLoaderObserver {
    public let completion: (Result<Data, Error>) -> Void
    
    public init(completion: @escaping (Result<Data, Error>) -> Void) {
        self.completion = completion
    }
    
    public func convert(url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
}
