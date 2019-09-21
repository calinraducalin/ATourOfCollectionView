//
//  ImageCell.swift
//  ATourOfCollectionView
//
//  Created by Calin Calin on 21/09/2019.
//  Copyright © 2019 Calin Radu Calin. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static let identifier = String(describing: ImageCell.self)
    
    private let imageView: UIImageView
    
    var image: UIImage? {
        didSet {
            imageView.backgroundColor = UIColor.random()
//            print(imageView.bounds)
        }
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        super.init(frame: frame)
        
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        imageView = UIImageView()
        super.init(coder: coder)
    }
    
    override var reuseIdentifier: String? {
        return ImageCell.identifier
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
