//
//  GifCollectionViewCell.swift
//  GifTest
//
//  Created by admin on 04.10.17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import FLAnimatedImage

class GifCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gifImage: FLAnimatedImageView!
    
    func setupWith(model: GifModel) {
        if let image = model.animatedImage {
            self.gifImage.animatedImage = image
            return
        }
        
        guard let url = URL(string:model.imageUrl) else { return }
        
        self.activityIndicator.startAnimating()
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let gif = FLAnimatedImage(animatedGIFData: data)
                DispatchQueue.main.async {
                    model.animatedImage = gif
                    self.gifImage.animatedImage = gif
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                print("error")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImage.animatedImage = nil
    }
}
