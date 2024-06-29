//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by macbook abdul on 27/05/2024.
//

import Foundation
import EssentialFeed
import EssentialFeediOS
import Combine

import UIKit

public final class CommentsUIComposer {
    private init(){}
    
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>
    
    public static func commentsComposedWith(
        commentsLoader:@escaping () -> AnyPublisher<[FeedImage], Error>
    ) -> ListViewController{
      
        let loadResourcePresentationAdapter = FeedPresentationAdapter(loader: commentsLoader)
        let feedController = makeFeedViewController(title: ImageCommentsPresenter.title)
        feedController.onRefresh = loadResourcePresentationAdapter.loadResource
        
      
        loadResourcePresentationAdapter.presenter = LoadResourcePresenter(
            loadingView: WeakRefVirtualProxy(
                feedController
            ),
            errorView: WeakRefVirtualProxy(
                feedController
            ),
            resourceView: FeedViewAdapter(
                feedViewController: feedController,
                imageLoader:{_ in Empty<Data,Error>().eraseToAnyPublisher()}
            ), mapper: FeedPresenter.map
        )
        
        return feedController
    }
    
    
    
    
    
    private static func makeFeedViewController(title: String) -> ListViewController{
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = title
        return feedController
    }
    
    
    
}
