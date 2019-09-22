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
        var attributesArray = [UICollectionViewLayoutAttributes]()
        let firstMatchIndex = cachedAttributes.binarySearch { rect.intersects($0.frame) }
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }
        return attributesArray
    }
    
    //MARK: - Helper
    
    private func createAttributes(for cv: UICollectionView) {
        let maxImagesPerRow = 3
        let rowHeight: CGFloat = 250
        let contentWidth = cv.bounds.width
        let itemsCount = cv.numberOfItems(inSection: 0)
        
        var itemsCountOnCurrentRow = maxImagesPerRow
        var rowIndex: CGFloat = 0
        var firstItemIndexOnCurrentRow = 0
        
        while firstItemIndexOnCurrentRow < itemsCount {
            let remainingItems = itemsCount - firstItemIndexOnCurrentRow
            itemsCountOnCurrentRow = determineItemsCountOnCurrentRow(remainingItems, itemsCountOnCurrentRow, maxImagesPerRow)
            print("row: \(rowIndex) - items: \(itemsCountOnCurrentRow)")
            for itemIndexOnCurrentRow in 0 ..< itemsCountOnCurrentRow {
                let indexPath = IndexPath(item: firstItemIndexOnCurrentRow + itemIndexOnCurrentRow, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let y = determinY(itemIndexOnCurrentRow, rowHeight, rowIndex)
                let x = determinX(itemIndexOnCurrentRow, itemsCountOnCurrentRow, contentWidth)
                let width = determineWidth(itemsCountOnCurrentRow, itemIndexOnCurrentRow, contentWidth)
                let height = determineHeight(itemsCountOnCurrentRow, itemIndexOnCurrentRow, maxImagesPerRow, rowHeight)
                attributes.frame = CGRect(x: x, y: y, width: width, height: height)
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
    
    private func determineItemsCountOnCurrentRow(_ remainingItems: Int, _ itemsCountOnPreviousRow: Int, _ maxImagesPerRow: Int) -> Int {
        
        let itemsCountOnCurrentRow: Int
    
        if remainingItems < maxImagesPerRow {
            itemsCountOnCurrentRow = remainingItems
        } else {
            itemsCountOnCurrentRow = 1 + itemsCountOnPreviousRow % maxImagesPerRow
        }
        
        return itemsCountOnCurrentRow
    }
    
    private func determinY(_ itemIndexOnCurrentRow: Int, _ rowHeight: CGFloat, _ rowIndex: CGFloat) -> CGFloat {
        let y: CGFloat
        if itemIndexOnCurrentRow < 2 {
            y = rowHeight * rowIndex
        } else {
            y = rowHeight * rowIndex + rowHeight / 2
        }
        return y
    }
    
    private func determinX(_ itemIndexOnCurrentRow: Int, _ itemsCountOnCurrentRow: Int, _ contentWidth: CGFloat) -> CGFloat {
        let x: CGFloat
        if itemIndexOnCurrentRow == 0 {
            x = 0
        } else if itemsCountOnCurrentRow == 2 {
            x = contentWidth / 2
        } else {
            x = contentWidth * 2 / 3
        }
        return x
    }
    
    private func determineWidth(_ itemsCountOnCurrentRow: Int, _ itemIndexOnCurrentRow: Int, _ contentWidth: CGFloat) -> CGFloat {
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
        return width
    }
    
    private func determineHeight(_ itemsCountOnCurrentRow: Int, _ itemIndexOnCurrentRow: Int, _ maxImagesPerRow: Int, _ rowHeight: CGFloat) -> CGFloat {
        let height: CGFloat
        if itemsCountOnCurrentRow == maxImagesPerRow, itemIndexOnCurrentRow > 0 {
            height = rowHeight / 2
        } else {
            height = rowHeight
        }
        return height
    }
}

extension Collection {

    func binarySearch(predicate: (Iterator.Element) -> Bool) -> Index {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high)/2)
            if predicate(self[mid]) {
                low = index(after: mid)
            } else {
                high = mid
            }
        }
        return low
    }
}
