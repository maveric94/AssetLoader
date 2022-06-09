//
//  RemoteLoader.swift
//  
//
//  Created by Anton Protko on 10.06.22.
//

import Foundation

public enum RemoteLoaderData {
    case url(URL)
    case data(Data)
}

public protocol RemoteLoader {
    init(url: URL, completion: @escaping (Result<RemoteLoaderData, Error>) -> Void)
}
