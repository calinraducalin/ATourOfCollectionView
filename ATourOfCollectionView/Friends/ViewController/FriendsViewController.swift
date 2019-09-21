//
//  FriendsViewController.swift
//  ATourOfCollectionView
//
//  Created by Calin Calin on 21/09/2019.
//  Copyright © 2019 Calin Radu Calin. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ColumnFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension FriendsViewController: UICollectionViewDataSource {
    
}

extension FriendsViewController: UICollectionViewDelegate {
    
}

class ColumnFlowLayout: UICollectionViewFlowLayout {
    
}
