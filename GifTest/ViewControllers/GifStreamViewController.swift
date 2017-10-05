//
//  ViewController.swift
//  GifTest
//
//  Created by admin on 04.10.17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import FLAnimatedImage
import IGListKit

class GifStreamViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let kGifCollectionViewCellIdentifier = "GifCollectionViewCell"
    
    var loading = false
    
    let spinToken = "spinner"
    
    var dataSource = [ListDiffable]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize : 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.dataSource = self
        adapter.collectionView = self.collectionView
        adapter.scrollViewDelegate = self
        p_getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func p_getData(){
        if APIFetcher.sharedInstance.getGifList(searchString: self.searchBar.text, completion: { response in
            self.dataSource = self.dataSource + response.gifs
            self.loading = false
            self.adapter.performUpdates(animated: true, completion: nil)
        }) {
            loading = true
        } else {
            loading = false
        }
    }
            
}

extension GifStreamViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if loading {
            return  dataSource + [self.spinToken as ListDiffable]
        }
        return dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? String, obj == spinToken {
            return spinnerSectionController()
        } else {
            let controller = GifListSectionController()
            controller.output = self
            return controller
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
    
}

extension GifStreamViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dataSource = [ListDiffable]()
        self.p_getData()
    }
}

extension GifStreamViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 100 {
            loading = true
            adapter.performUpdates(animated: true, completion: nil)
            self.p_getData()
        }
    }
}

extension GifStreamViewController : GifListSectionControllerOutput {
    func didRequestPresentAlert(_ model : GifModel) {
        let alertController = UIAlertController(title: "", message: "url : \(model.imageUrl)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

