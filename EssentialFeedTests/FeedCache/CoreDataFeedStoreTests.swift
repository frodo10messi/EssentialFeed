//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by macbook abdul on 02/05/2024.
//

import Foundation
import XCTest
import EssentialFeed

class CoreDataFeedStore:FeedStore{
    func deleteCacheFeed(completion: @escaping deleteCompletion) {
         
    }
    
    func insert(_ items: [EssentialFeed.LocalFeedImage], timeStamp: Date, completion: @escaping insertCompletion) {
         
    }
    
    func retrieve(completion: @escaping retrieveCompletion) {
        completion(.empty)
    }
}
class CoreDataFeedStoreTests:XCTestCase,FeedStoreSpecs{
    func test_retrieve_deliversEmptyOnEmptyCache() {
         let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on:sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
         
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
         
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
         
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
         
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
         
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
         
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
         
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
         
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
         
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
         
    }
    
    func test_storeSideEffects_runSerially() {
         
    }
    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore{
        let sut = CoreDataFeedStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
