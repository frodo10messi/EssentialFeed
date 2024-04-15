//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by macbook abdul on 06/04/2024.
//

import Foundation
import XCTest
import EssentialFeed


class CacheFeedUseCaseTests:XCTestCase{
    func test_init_doesNotMessageStoreUponCreation(){
        let (store,_) = makeSut()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_save_requestsCacheDeletion(){
        
        let (store,sut) = makeSut()
        let items = uniqueImages()
        sut.save(items:items.models, completion: {_ in})
        
        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError(){
        let (store,sut) = makeSut()
        let items = uniqueImages()
        let deletionError = anyError()
        
        sut.save(items:items.models, completion: {_ in})
        
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
        
    }
    
    
    func test_save_requestsNewCacheWithTimeStampInsertionOnSuccessfulDeletion(){
        let date = Date()
        let (store,sut) = makeSut(currentTimeStamp: {date})
        let items = uniqueImages()
        
        
        sut.save(items:items.models, completion: {_ in})
        store.completeDeletionSuccessFully()
        
        
        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed,.insert(items: items.local, timeStamp: date)])
        
    }
    
    func test_save_failsOnDeletionError(){
        let date = Date()
        let (store,sut) = makeSut(currentTimeStamp: {date})
        let deletionError = anyError()
        
        
        expect(sut: sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
        
        
    }
    
    func test_save_failsOnInsertionErrorOnSuccessfulDeletion(){
        let date = Date()
        let (store,sut) = makeSut(currentTimeStamp: {date})
        let insertionError = anyError()
        
        expect(sut: sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessFully()
            store.completeInsertion(with: insertionError)
        })
        
        
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion(){
        let date = Date()
        let (store,sut) = makeSut(currentTimeStamp: {date})
        
        expect(sut: sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessFully()
            store.completeInsertionSuccessfully()
        })
        
        
    }
    
    func test_save_DoesNotDeliverDeletionErrorAfterSutHasBeenDisallocated(){
        var sut:LocalFeedStore?
        let store = FeedStoreSpy()
        sut = LocalFeedStore(store:store, currentTimeStamp:  Date.init)
        let items = uniqueImages()
        
        var receivedError = [LocalFeedStore.saveResult]()
        sut?.save(items: items.models, completion: { error in
            receivedError.append(error)
        })
        
        sut = nil
        store.completeDeletion(with:anyError())
        
        XCTAssertTrue(receivedError.isEmpty)
        
        
        
        
    }
    
    func test_save_DoesNotDeliverInsertionErrorAfterSutHasBeenDisallocated(){
        var sut:LocalFeedStore?
        let store = FeedStoreSpy()
        sut = LocalFeedStore(store:store, currentTimeStamp:  Date.init)
        
        let items = uniqueImages()
        var receivedError = [LocalFeedStore.saveResult]()
        
        sut?.save(items:items.models , completion: { error in
            receivedError.append(error)
            
        })
        
        store.completeDeletionSuccessFully()
        sut = nil
        store.completeInsertion(with: anyError())
        
        XCTAssertTrue(receivedError.isEmpty)
        
    }
    
    func expect(sut:LocalFeedStore,toCompleteWithError expectedError:NSError?,when action:()->Void,file:StaticString = #file,line:UInt = #line){
        var receievedResults = [LocalFeedStore.saveResult]()
        let expectation = expectation(description: "wait for save completion")
        
        sut.save(items: [uniqueImage()]) { error in
            receievedResults.append(error)
            expectation.fulfill()
        }
        
        action()
        XCTAssertEqual(receievedResults.map{$0 as NSError?},[expectedError])
        wait(for: [expectation],timeout: 0.1)
    }
    
    func makeSut(
        currentTimeStamp:@escaping () -> Date = Date.init,
        file:StaticString = #file,
        line:UInt = #line
    ) -> (
        FeedStoreSpy,
        LocalFeedStore
    ){
        let store = FeedStoreSpy()
        let localFeedStore = LocalFeedStore(store: store, currentTimeStamp: currentTimeStamp)
        trackForMemoryLeaks(store,file: file,line: line)
        trackForMemoryLeaks(localFeedStore,file: file,line: line)
        return (store,localFeedStore)
    }
    
    

}
