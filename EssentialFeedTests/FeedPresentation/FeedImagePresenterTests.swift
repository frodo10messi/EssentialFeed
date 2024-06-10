//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by macbook abdul on 10/06/2024.
//

import Foundation
import XCTest
import EssentialFeed

struct FeedImageViewModel{
    let location:String?
    let description:String?
    let image:Any?
    let isLoading:Bool
    let shouldRetry:Bool
    
    var hasLocation: Bool {
        return location != nil
    }
    
}


protocol FeedImageView {
    func display(_ viewModel:FeedImageViewModel)

}
class FeedImagePresenter {
    let view:FeedImageView
    
    init(view: FeedImageView) {
        self.view = view
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
         view.display(FeedImageViewModel(
            location: model.location, description: model.description,
             image: nil,
             isLoading: true,
             shouldRetry: false))
     }
    
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessageToView(){
        let (_,view) = makeSUT()
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoadingImageData_displaysLoadingImage(){
        let (sut,view) = makeSUT()
        let image = uniqueImage()
        
        sut.didStartLoadingImageData(for: image)
        
        
        let message = view.messages.first
                XCTAssertEqual(view.messages.count, 1)
                XCTAssertEqual(message?.description, image.description)
                XCTAssertEqual(message?.location, image.location)
                XCTAssertEqual(message?.isLoading, true)
                XCTAssertEqual(message?.shouldRetry, false)
                XCTAssertNil(message?.image)

    }
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
            let view = ViewSpy()
            let sut = FeedImagePresenter(view: view)
            trackForMemoryLeaks(view, file: file, line: line)
            trackForMemoryLeaks(sut, file: file, line: line)
            return (sut, view)
        }
    
    
    private class ViewSpy:FeedImageView {
        
        var messages = [FeedImageViewModel]()
        
        func display(_ viewModel: FeedImageViewModel) {
            messages.append(viewModel)
        }
        
    }
    
    
}
