//
//  AssetError.swift
//  
//
//  Created by Anton Protko on 10.06.22.
//

public enum AssetError: Error {
    case illegalAsset
    case network(error: Error?)
    case file(error: Error)
    case storage(error: Error)
    case imageNotLoaded
}
