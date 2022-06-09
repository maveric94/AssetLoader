//
//  Asset.swift
// 
//
//  Created by Anton Protko on 10.06.22.
//

import Foundation

public protocol Asset {
    var key: String { get }
    var checksum: String? { get }
    
    var remoteUrl: URL? { get }
    var downloadedUrl: URL? { get }
    var builtInUrl: URL? { get }
}

public func ==(left: Asset, right: Asset) -> Bool {
    left.key == right.key
}
