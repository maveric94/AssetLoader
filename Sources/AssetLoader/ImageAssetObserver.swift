//
//  ImageAssetObserver.swift
// 
//
//  Created by Anton Protko on 10.06.22.
//

import Foundation
import UIKit

public class ImageAssetObserver: BlockAssetLoaderObserver {
    public let completion: (Result<UIImage, Error>) -> Void
    
    public init(completion: @escaping (Result<UIImage, Error>) -> Void) {
        self.completion = completion
    }
    
    public func convert(url: URL) throws -> UIImage {
        guard let image = UIImage(data: try Data(contentsOf: url)) else {
            throw AssetError.imageNotLoaded
        }
        
        return image
    }
}
