//
//  ZCyclePageControl.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/18.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

public enum ZCyclePageControlAlignment {
    case center
    case left
    case right
}

class ZCyclePageControl: UIControl {
    
    var numberOfPages: Int = 0 {
        didSet { setupItems() }
    }
    var controlSpacing: CGFloat = 8 {
        didSet { updateFrame() }
    }
    var controlSize: CGSize = CGSize(width: 8, height: 8) {
        didSet { updateFrame() }
    }
    var currentControlSize: CGSize? {
        didSet { updateFrame() }
    }
    var alignment: ZCyclePageControlAlignment = .center {
        didSet { updateFrame() }
    }
    var itemCornerRadius: CGFloat? {
        didSet { updateFrame() }
    }
    var currentItemCornerRadius: CGFloat? {
        didSet { updateFrame() }
    }
    var currentPage: Int = 0 {
        didSet { changeColor(); updateFrame() }
    }
    var currentPageIndicatorTintColor: UIColor = UIColor.white {
        didSet { changeColor() }
    }
    var pageIndicatorTintColor: UIColor = UIColor.gray {
        didSet { changeColor() }
    }
    var itemImage: UIImage? {
       didSet { changeColor() }
    }
    var currentItemImage: UIImage? {
        didSet { changeColor() }
    }
    
    fileprivate var items = [UIImageView]()
    
    func changeColor() {
        for (index, item) in items.enumerated() {
            if currentPage == index {
                item.backgroundColor = currentItemImage == nil ? currentPageIndicatorTintColor : UIColor.clear
                item.image = currentItemImage
                if currentItemImage != nil { item.layer.cornerRadius = 0 }
            } else {
                item.backgroundColor = itemImage == nil ? pageIndicatorTintColor : UIColor.clear
                item.image = itemImage
                if itemImage != nil { item.layer.cornerRadius = 0 }
            }
        }
    }
    
    func updateFrame() {
        for (index, item) in items.enumerated() {
            let frame = getFrame(index: index)
            item.frame = frame
            var radius = itemCornerRadius == nil ? frame.size.height/2 : itemCornerRadius!
            if currentPage == index {
                if currentItemImage != nil { radius = 0 }
                item.layer.cornerRadius = currentItemCornerRadius == nil ? radius : currentItemCornerRadius!
            } else {
                if itemImage != nil { radius = 0 }
                item.layer.cornerRadius = radius
            }
            item.layer.masksToBounds = true
        }
    }
    
    func getFrame(index: Int) -> CGRect {
        let itemW = controlSize.width + controlSpacing
        var currentSize = currentControlSize
        if currentSize == nil {
            currentSize = controlSize
        }
        let currentItemW = (currentSize?.width)! + controlSpacing
        let totalWidth = itemW*CGFloat(numberOfPages-1)+currentItemW+controlSpacing
        var orignX: CGFloat = 0
        switch alignment {
        case .center:
            orignX = (frame.size.width-totalWidth)/2+controlSpacing
        case .left:
            orignX = controlSpacing
        case .right:
            orignX = frame.size.width-totalWidth+controlSpacing
        }
        var x: CGFloat = 0
        if index <= currentPage {
            x = orignX + CGFloat(index)*itemW
        } else {
            x = orignX + CGFloat(index-1)*itemW + currentItemW
        }
        
        let width = index == currentPage ? (currentSize?.width)! : controlSize.width
        let height = index == currentPage ? (currentSize?.height)! : controlSize.height
        let y = (frame.size.height-height)/2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func setupItems() {
        for item in items { item.removeFromSuperview() }
        items.removeAll()
        for i in 0..<numberOfPages {
            let frame = getFrame(index: i)
            let item = UIImageView(frame: frame)
            addSubview(item)
            items.append(item)
        }
        isHidden = numberOfPages <= 1 ? true : false
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self { return nil }
        return hitView
    }
}
