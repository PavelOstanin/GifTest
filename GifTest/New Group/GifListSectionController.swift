//
//  GifListSectionController.swift
//  GifTest
//
//  Created by admin on 04.10.17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import IGListKit

protocol GifListSectionControllerOutput : class {
    func didRequestPresentAlert(_ model : GifModel)
}

class GifListSectionController: ListSectionController {
        
    // MARK: - Properties
    fileprivate(set) var model: GifModel?
    fileprivate(set) var numberOfColumn: Int = 1
    
    weak var output : GifListSectionControllerOutput?
    
    private let kGifCollectionViewCellIdentifier = "GifCollectionViewCell"
    
    override init() {
        super.init()
        self.minimumInteritemSpacing = 1.0
        self.minimumLineSpacing = 1.0
    }
    
}

extension GifListSectionController {
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerWidth = self.collectionContext?.containerSize.width else { return .zero }
        let imageSize = model!.imageSize()
        let size = CGSize(width: containerWidth / CGFloat(numberOfColumn), height: (containerWidth / CGFloat(numberOfColumn)) * imageSize.height / imageSize.width)
        return size
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: self.kGifCollectionViewCellIdentifier,
                                                                        for: self,
                                                                        at: index) as! GifCollectionViewCell
        cell.setupWith(model: model!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.model = object as? GifModel
    }
    
    override func didSelectItem(at index: Int) {
        self.collectionContext?.deselectItem(at: index, sectionController: self, animated: true)
        guard let item = self.model else { return }
        self.output?.didRequestPresentAlert(item)
    }
}
