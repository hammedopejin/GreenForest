//
//  ImageCollectionViewCell.swift
//  GreenForest
//
//  Created by Hammed opejin on 2/2/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImage
    }
}
