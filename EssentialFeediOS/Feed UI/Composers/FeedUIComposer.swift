//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by macbook abdul on 27/05/2024.
//

import Foundation
import EssentialFeed
import UIKit

public final class FeedUIComposer {
    private init(){}
    
    
    public static func feedComposedWith(
        loader: FeedLoader,
        imageLoader:FeedImageLoader
    ) -> FeedViewController{
        let presenter = FeedPresenter(feedLoader: loader)
        let refreshController = FeedRefreshViewController(presenter: presenter)
        presenter.feedLoadingView = WeakRefVirtualProxy(refreshController)

        let feedViewController = FeedViewController(refreshController: refreshController)
        let adapter = FeedViewAdapter(imageLoader: imageLoader)
        adapter.feedViewController = feedViewController
        
        presenter.feedView = adapter
      return feedViewController
    }
    
}

class WeakRefVirtualProxy<T:AnyObject>{
    
    weak var object:T?
    
    init(_ object: T?) {
        self.object = object
    }
}
extension WeakRefVirtualProxy:FeedLoadingView where T:FeedLoadingView{
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
    
    
}



class FeedViewAdapter:FeedView{
    weak var feedViewController: FeedViewController?
    let imageLoader:  FeedImageLoader
    
    init(imageLoader: FeedImageLoader) {
        self.imageLoader = imageLoader
    }
    func display(feed: [FeedImage]) {
        
        feedViewController?.tableModel = feed.map({
            feed in
            return FeedImageCellController(
                viewModel: FeedImageViewModel(
                    model: feed,
                    imageLoader:imageLoader,
                    transformer: UIImage.init
                )
            )
        })
    }
    
    
}