//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by macbook abdul on 17/06/2024.
//

import Foundation
public protocol FeedImageDataCache {
//    typealias Result = Swift.Result<Void, Error>
//
//    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
    func save(_ data: Data, for url: URL) throws

    
}
