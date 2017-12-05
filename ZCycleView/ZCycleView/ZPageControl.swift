//
//  ZPageControl.swift
//  ZPageControl
//
//  Created by mengqingzheng on 2017/11/18.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

public enum ZPageControlAlignment {
    case center
    case left
    case right
}

public class ZPageControl: UIControl {
    /// The number of dots
    public var numberOfPages: Int = 0 {
        didSet { setupItems() }
    }
    /// Dot pitch
    public var spacing: CGFloat = 8 {
        didSet { updateFrame() }
    }
    /// Dot size
    public var dotSize: CGSize = CGSize(width: 8, height: 8) {
        didSet { updateFrame() }
    }
    /// Current dot size
    public var currentDotSize: CGSize? {
        didSet { updateFrame() }
    }
    /// Dot alignment
    public var alignment: ZPageControlAlignment = .center {
        didSet { updateFrame() }
    }
    /// Dot radius
    public var dotRadius: CGFloat? {
        didSet { updateFrame() }
    }
    /// Current dot radius
    public var currentDotRadius: CGFloat? {
        didSet { updateFrame() }
    }
    /// Current page
    public var currentPage: Int = 0 {
        didSet { changeColor(); updateFrame() }
    }
    /// CurrentPageIndicatorTintColor
    public var currentPageIndicatorTintColor: UIColor = UIColor.white {
        didSet { changeColor() }
    }
    /// PageIndicatorTintColor
    public var pageIndicatorTintColor: UIColor = UIColor.gray {
        didSet { changeColor() }
    }
    /// Dot image
    public var dotImage: UIImage? {
       didSet { changeColor() }
    }
    /// Current dot image
    public var currentDotImage: UIImage? {
        didSet { changeColor() }
    }
    /// hidesForSinglePage
    var hidesForSinglePage: Bool = false {
        didSet { isHidden = hidesForSinglePage && numberOfPages == 1 ? true : false }
    }
    fileprivate var items = [UIImageView]()
    fileprivate func changeColor() {
        for (index, item) in items.enumerated() {
            if currentPage == index {
                item.backgroundColor = currentDotImage == nil ? currentPageIndicatorTintColor : UIColor.clear
                item.image = currentDotImage
                if currentDotImage != nil { item.layer.cornerRadius = 0 }
            } else {
                item.backgroundColor = dotImage == nil ? pageIndicatorTintColor : UIColor.clear
                item.image = dotImage
                if dotImage != nil { item.layer.cornerRadius = 0 }
            }
        }
    }
    
    func updateFrame() {
        for (index, item) in items.enumerated() {
            let frame = getFrame(index: index)
            item.frame = frame
            var radius = dotRadius == nil ? frame.size.height/2 : dotRadius!
            if currentPage == index {
                if currentDotImage != nil { radius = 0 }
                item.layer.cornerRadius = currentDotRadius == nil ? radius : currentDotRadius!
            } else {
                if dotImage != nil { radius = 0 }
                item.layer.cornerRadius = radius
            }
            item.layer.masksToBounds = true
        }
    }
    
    fileprivate func getFrame(index: Int) -> CGRect {
        let itemW = dotSize.width + spacing
        var currentSize = currentDotSize
        if currentSize == nil {
            currentSize = dotSize
        }
        let currentItemW = (currentSize?.width)! + spacing
        let totalWidth = itemW*CGFloat(numberOfPages-1)+currentItemW+spacing
        var orignX: CGFloat = 0
        switch alignment {
        case .center:
            orignX = (frame.size.width-totalWidth)/2+spacing
        case .left:
            orignX = spacing
        case .right:
            orignX = frame.size.width-totalWidth+spacing
        }
        
        var x: CGFloat = 0
        if index <= currentPage {
            x = orignX + CGFloat(index)*itemW
        } else {
            x = orignX + CGFloat(index-1)*itemW + currentItemW
        }
        let width = index == currentPage ? (currentSize?.width)! : dotSize.width
        let height = index == currentPage ? (currentSize?.height)! : dotSize.height
        let y = (frame.size.height-height)/2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    fileprivate func setupItems() {
        for item in items { item.removeFromSuperview() }
        items.removeAll()
        for i in 0..<numberOfPages {
            let frame = getFrame(index: i)
            let item = UIImageView(frame: frame)
            addSubview(item)
            items.append(item)
        }
        updateFrame()
        changeColor()
    }
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self { return nil }
        return hitView
    }
}
