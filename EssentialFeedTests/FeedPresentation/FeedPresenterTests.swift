//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by macbook abdul on 10/06/2024.
//

import Foundation
import XCTest
import EssentialFeed

struct FeedErrorViewModel {
    let message: String?
}

struct FeedLoadingViewModel {
    let isLoading: Bool
}
struct FeedViewModel {
    let feed: [FeedImage]
}
protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}
protocol FeedLoadingView{
    func display(_ viewModel:FeedLoadingViewModel)
}
protocol FeedView{
    func display(_ viewModel:FeedViewModel)
}
final class FeedPresenter {
    
    private let feedLoadingView:FeedLoadingView
    private let errorView: FeedErrorView
    private let feedView:FeedView
    
    init(feedLoadingView: FeedLoadingView, errorView: FeedErrorView, feedView: FeedView) {
        self.feedLoadingView = feedLoadingView
        self.errorView = errorView
        self.feedView = feedView
    }
    
    func didStartLoadingFeed(){
        errorView.display(.init(message: .none))
        feedLoadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed :[FeedImage]){
        feedView.display(FeedViewModel(feed: feed))
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))

    }
}
class FeedPresenterTests: XCTestCase {
    
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    func test_didStartLoadingFeed_startsLoadingAndDisplaysNoError() {
        
        let (sut, view) = makeSUT()

        sut.didStartLoadingFeed()
        
        XCTAssertEqual(
            view.messages,
            
            [.feedLoading(
                isLoading: true
            ),
             .displayError(message:.none)
            ]
        )
        
    }
    
    func test_didFinishLoadingFeed_displaysFeedAndStopsLoading() {
        let (sut, view) = makeSUT()
        let feed = uniqueImages().models

        sut.didFinishLoadingFeed(with: feed)
        
        XCTAssertEqual(view.messages,[.displayFeed(feed: feed),.feedLoading(isLoading: false)])
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(feedLoadingView: view, errorView: view, feedView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy:FeedLoadingView,FeedErrorView,FeedView {
        
        
        enum Message:Hashable {
            case feedLoading(isLoading: Bool)
            case displayError(message:String?)
            case displayFeed(feed:[FeedImage])
            
        }
        var messages = Set<Message>()
        
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.feedLoading(isLoading: viewModel.isLoading))
        }
        func display(_ viewModel: FeedViewModel) {
            messages.insert(.displayFeed(feed: viewModel.feed))
        }
        
        func display(_ viewModel:FeedErrorViewModel) {
            messages.insert(.displayError(message: viewModel.message))
        }
        
        
        
    }
    
}




