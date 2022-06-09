//
//  AssetsChecksumStorage.swift
// 
//
//  Created by Anton Protko on 10.06.22.
//

import Foundation

public protocol AssetsChecksumStorage {
    func getValue(key: String) throws -> String?
    func setValue(_ value: String?, key: String) throws
}

extension AssetsChecksumStorage {
    func isAssetChecksumValid(_ asset: Asset) throws -> Bool {
        return try asset.checksum != nil && getValue(key: asset.key) == asset.checksum
    }
    
    func updateAssetChecksum(_ asset: Asset) throws {
        try setValue(asset.checksum, key: asset.key)
    }
}

public class AssetsUserDefaultsChecksumStorage {
    private let storage: UserDefaults
    
    init(storage: UserDefaults) {
        self.storage = storage
    }
    
    func getValue(key: String) -> String? {
        storage.string(forKey: key)
    }
    
    func setValue(_ value: String?, key: String) {
        storage.set(value, forKey: key)
    }    
}
