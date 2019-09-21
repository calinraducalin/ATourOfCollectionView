//
//  FriendsViewController.swift
//  ATourOfCollectionView
//
//  Created by Calin Calin on 21/09/2019.
//  Copyright © 2019 Calin Radu Calin. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: ColumnFlowLayout())
        collectionView.register(UINib(nibName: PersonCell.identifier, bundle: nil), forCellWithReuseIdentifier: PersonCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let customButton = UIButton(type: .custom)
        customButton.layer.masksToBounds = true
        customButton.layer.cornerRadius = 5
        customButton.setImage(#imageLiteral(resourceName: "person5.jpg"), for: .normal)
        
        let barButtonItem = UIBarButtonItem(customView: customButton)
        
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        return barButtonItem
    }()
    
    private var people: [Person] = [
        Person(name: "Steve", image: #imageLiteral(resourceName: "person1.jpg"), lastUpdate: Calendar.current.date(byAdding: .hour, value: -1, to: Date())),
        Person(name: "Mohammed", image: #imageLiteral(resourceName: "person2.jpg"), lastUpdate: Calendar.current.date(byAdding: .day, value: -1, to: Date())),
        Person(name: "Samir", image: #imageLiteral(resourceName: "person3.jpg"), lastUpdate: Calendar.current.date(byAdding: .month, value: -1, to: Date())),
        Person(name: "Priyanka", image: #imageLiteral(resourceName: "person4.jpg"), lastUpdate: Calendar.current.date(byAdding: .year, value: -1, to: Date()))
    ]
}

extension FriendsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.identifier, for: indexPath) as! PersonCell
        cell.person = people[indexPath.item]
        return cell
    }
}

extension FriendsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedViewController = FeedViewController()
        feedViewController.person = people[indexPath.item]
        navigationController?.pushViewController(feedViewController, animated: true)
    }
}
