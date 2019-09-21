//
//  PersonCell.swift
//  ATourOfCollectionView
//
//  Created by Calin Calin on 21/09/2019.
//  Copyright © 2019 Calin Radu Calin. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    static let identifier = String(describing: PersonCell.self)

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var detailsTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 16
        imageView.layer.cornerRadius = 16
    }
    
    var person: Person? {
        didSet { configure() }
    }
    
    func configure() {
        imageView.image = person?.image
        textLabel.text = personFeedText
        detailsTextLabel.text = lastUpdatedText
    }
    
    override var reuseIdentifier: String? {
        return PersonCell.identifier
    }
    
    private var personFeedText: String? {
        guard let name = person?.name else { return nil }
        return "\(name)'s Feed"
    }
    
    private var lastUpdatedText: String? {
        guard let date = person?.lastUpdate else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateText = dateFormatter.string(from: date)
        return "Updated \(dateText)"
    }
}
