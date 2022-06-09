//
//  UrlAssetObserver.swift
// 
//
//  Created by Anton Protko on 10.06.22.
//
//
import Foundation

public class UrlAssetObserver: BlockAssetLoaderObserver {
    public let completion: (Result<URL, Error>) -> Void
    
    public init(completion: @escaping (Result<URL, Error>) -> Void) {
        self.completion = completion
    }
    
    public func convert(url: URL) throws -> URL {
        url
    }
}

