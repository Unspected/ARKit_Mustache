//
//  MustacheCollectionViewCell.swift
//  Mustache_app
//
//  Created by Pavel Andreev on 3/15/23.
//

import UIKit

class MustacheCollectionViewCell: UICollectionViewCell {
    
    var imageContainer = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageContainer.contentMode = .scaleAspectFit
        imageContainer.frame = contentView.bounds
        backgroundColor = UIColor(white: 1, alpha: 0.3)
        contentView.addSubview(imageContainer)
        layer.cornerRadius = frame.height / 2

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
