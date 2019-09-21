//
//  MosaicLayout.swift
//  ATourOfCollectionView
//
//  Created by Calin Calin on 21/09/2019.
//  Copyright © 2019 Calin Radu Calin. All rights reserved.
//

import UIKit

class MosaicLayout: UICollectionViewLayout {
    
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        
        // Reset cached info
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: cv.bounds.size)
        
        // for every item
        //  - Prepare attributes
        //  - Store attributes in cachedAttributes array
        //  - union contentBounds with attributes.frame
        createAttributes(for: cv)
    }
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView else { return false }
        return !newBounds.size.equalTo(cv.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { attributes -> Bool in
            return rect.intersects(attributes.frame)
        }
    }
    
    //MARK: - Helper
    
    private let imagesPerRow = [1, 2, 3]
    
    private func createAttributes(for cv: UICollectionView) {
        
        let contentWidth = cv.bounds.width
        let isPortrait = cv.bounds.width < cv.bounds.height
        let rowHeight: CGFloat = 150
        let itemsCount = cv.numberOfItems(inSection: 0)
        var itemsCountOnCurrentRow = imagesPerRow.last!
        var rowIndex: CGFloat = 0
        var firstItemIndexOnCurrentRow = 0
        
        while firstItemIndexOnCurrentRow < itemsCount {
            let remainingItems = itemsCount - firstItemIndexOnCurrentRow
            itemsCountOnCurrentRow = determineItemsCountOnCurrentRow(remainingItems: remainingItems, itemsCountOnPreviousRow: itemsCountOnCurrentRow, isPortrait: isPortrait)
            print("row: \(rowIndex) - items: \(itemsCountOnCurrentRow)")
            for itemIndexOnCurrentRow in 0 ..< itemsCountOnCurrentRow {
                let y: CGFloat
                if itemIndexOnCurrentRow < 2 {
                    y = rowHeight * rowIndex
                } else {
                    y = rowHeight * rowIndex + rowHeight / 2
                }
                
                let x: CGFloat
                if itemIndexOnCurrentRow == 0 {
                    x = 0
                } else if itemsCountOnCurrentRow == 2 {
                    x = contentWidth / 2
                } else {
                    x = contentWidth * 2 / 3
                }
                
                let width: CGFloat
                if itemsCountOnCurrentRow == 1 {
                    width = contentWidth
                } else if itemsCountOnCurrentRow == 2 {
                    width = contentWidth / 2
                } else if itemIndexOnCurrentRow == 0 {
                    width = contentWidth * 2 / 3
                } else {
                    width = contentWidth / 3
                }
                
                let height: CGFloat
                if itemsCountOnCurrentRow == 3, itemIndexOnCurrentRow > 0 {
                    height = rowHeight / 2
                } else {
                    height = rowHeight
                }
                
                let indexPath = IndexPath(item: firstItemIndexOnCurrentRow + itemIndexOnCurrentRow, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: x, y: y, width: width, height: height)
                print("itemIndex: \(indexPath.item) - frame: \(attributes.frame)")
                print(attributes)
                cachedAttributes.append(attributes)
            }
            
            rowIndex += 1
            firstItemIndexOnCurrentRow += itemsCountOnCurrentRow
        }
        
        if let lastAttribute = cachedAttributes.last {
            contentBounds.size.height = max(cv.bounds.height, lastAttribute.frame.maxY)
            print(contentBounds)
        }
    }
    
    private func determineItemsCountOnCurrentRow(remainingItems: Int, itemsCountOnPreviousRow: Int, isPortrait: Bool) -> Int {
        
        let itemsCountOnCurrentRow: Int
    
        itemsCountOnCurrentRow = 1 + itemsCountOnPreviousRow % 3
        
        return itemsCountOnCurrentRow
    }
}
