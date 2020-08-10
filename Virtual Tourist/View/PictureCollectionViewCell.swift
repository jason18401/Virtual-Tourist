//
//  PictureCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Jason Yu on 8/9/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    static let reuseID = "pictureReuseCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        
    public func configure(with image: UIImage) {
        imageView.image = image
    }

}
