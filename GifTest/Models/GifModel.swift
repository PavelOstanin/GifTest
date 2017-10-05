//
//  GifModel.swift
//  GifTest
//
//  Created by admin on 04.10.17.
//  Copyright © 2017 iosdev. All rights reserved.
//
import UIKit
import IGListKit
import FLAnimatedImage

class GifModel {
    
    var imageUrl: String
    
    var height: Int
    
    var width: Int
    
    var animatedImage: FLAnimatedImage?
    
    func imageSize() -> CGSize {
        return CGSize(width: self.width, height: self.height)
    }
    
    init(url: String, width: Int, height: Int) {
        self.imageUrl = url
        self.height = height
        self.width = width
    }
}

extension GifModel {
    
    convenience init?(dict: [String: Any]?) {
        guard let dict = dict else { return nil }
        guard let url = dict["url"] as? String
        else { return nil }
        let height = dict["height"] as AnyObject
        let width = dict["width"] as AnyObject
        self.init(url: url, width: width.intValue, height: height.intValue)
    }
}

extension GifModel : ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self.imageUrl as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? GifModel else { return false }
        return self.imageUrl == object.imageUrl
    }
}

