//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by macbook abdul on 09/05/2024.
//

import UIKit
import EssentialFeed

public class FeedViewController:UITableViewController {
    private var loader:FeedLoader?
    private var onViewDidAppear:((FeedViewController) -> Void)?
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
       
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        onViewDidAppear = { vc in
            vc.onViewDidAppear = nil
            vc.load()
        }
        
        
    }
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        onViewDidAppear?(self)
    }
    
    @objc func load(){
        refreshControl?.beginRefreshing()
        loader?.load(completion: { [refreshControl] _ in
            refreshControl?.endRefreshing()
        })
    }
}