//
//  ZCycleLayout.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/24.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

class ZCycleLayout: UICollectionViewFlowLayout {

    var scale: CGFloat = 1 {
        didSet {
            if scale > 1 {
                invalidateLayout()
            }
        }
    }
    override func prepare() {
        super.prepare()
        if let collectionView = collectionView {
            if scrollDirection == .horizontal {
                let offset = (collectionView.frame.size.width-itemSize.width)/2
                sectionInset = UIEdgeInsetsMake(0, offset, 0, 0)
            } else {
                let offset = (collectionView.frame.size.height-itemSize.height)/2
                sectionInset = UIEdgeInsetsMake(offset, 0, 0, 0)
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect),
            let collectionView = collectionView {
            let attris = NSArray(array: attributes, copyItems:true) as! [UICollectionViewLayoutAttributes]
            for attri in attris {
                var scale: CGFloat = 1
                var absOffset: CGFloat = 0
                let centerX = collectionView.bounds.size.width*0.5 + collectionView.contentOffset.x
                let centerY = collectionView.bounds.size.height*0.5 + collectionView.contentOffset.y
                if scrollDirection == .horizontal {
                    absOffset = abs(attri.center.x-centerX)
                    let distance = itemSize.width+minimumLineSpacing
                    if absOffset < distance {///当前index
                        scale = (1-absOffset/distance)*(self.scale-1) + 1
                    }
                } else {
                    absOffset = abs(attri.center.y-centerY)
                    let distance = itemSize.height+minimumLineSpacing
                    if absOffset < distance {
                        scale = (1-absOffset/distance)*(self.scale-1) + 1
                    }
                }
                
                attri.zIndex = Int(scale * 1000)
                attri.transform = CGAffineTransform(scaleX:scale,y: scale)
            }
            return attris
        }
        return nil
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var minSpace = CGFloat.greatestFiniteMagnitude
        var offset = proposedContentOffset
        if let collectionView = collectionView {
            let centerX = offset.x+collectionView.bounds.size.width/2
            let centerY = offset.y+collectionView.bounds.size.height/2
            var visibleRect: CGRect
            if scrollDirection == .horizontal {
                visibleRect = CGRect(origin: CGPoint(x: offset.x, y: 0), size: collectionView.bounds.size)
            } else {
                visibleRect = CGRect(origin: CGPoint(x: 0, y: offset.y), size: collectionView.bounds.size)
            }
            if let attris = layoutAttributesForElements(in: visibleRect) {
                for attri in attris {
                    if scrollDirection == .horizontal {
                        if abs(minSpace) > abs(attri.center.x-centerX) {
                            minSpace = attri.center.x-centerX
                        }
                    } else {
                        if abs(minSpace) > abs(attri.center.y-centerY) {
                            minSpace = attri.center.y-centerY
                        }
                    }
                }
            }
            if scrollDirection == .horizontal {
                offset.x+=minSpace
            } else {
                offset.y+=minSpace
            }
        }
        return offset
    }
}
