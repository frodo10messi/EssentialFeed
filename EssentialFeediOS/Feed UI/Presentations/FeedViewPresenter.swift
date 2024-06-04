//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by macbook abdul on 27/05/2024.
//

import Foundation
import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading:Bool
}
protocol FeedLoadingView{
    func display(_ viewModel:FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed:[FeedImage]
}
protocol FeedView{
    func display(_ viewModel:FeedViewModel)
}
class FeedPresenter {
    
    let feedLoadingView:FeedLoadingView
    let feedView:FeedView

   
    init(feedLoadingView: FeedLoadingView, feedView: FeedView) {
        self.feedLoadingView = feedLoadingView
        self.feedView = feedView
    }
    
    func didStartLoadingFeed(){
        feedLoadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed :[FeedImage]){
        feedView.display(FeedViewModel(feed: feed))
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))

    }
    func didFinishLoadingFeed(with: Error) {
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
}
