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
    /// page数量
    public var numberOfPages: Int = 0
    /// 圆点间距
    public var spacing: CGFloat = 8
    /// 圆点大小
    public var dotSize = CGSize(width: 8, height: 8)
    /// 当前圆点大小
    public var currentDotSize: CGSize?
    /// 圆点对齐方式
    public var alignment: ZPageControlAlignment = .center
    /// 圆点圆角
    public var dotRadius: CGFloat?
    /// 当前圆点圆角
    public var currentDotRadius: CGFloat?
    /// 当前位置
    public var currentPage: Int = 0 { didSet { updateFrame() } }
    /// 当前颜色
    public var currentPageIndicatorTintColor = UIColor.white
    /// 圆点颜色
    public var pageIndicatorTintColor = UIColor.gray
    /// 圆点图片
    public var dotImage: UIImage?
    /// 当前圆点图片
    public var currentDotImage: UIImage?
    
    private var items = [UIImageView]()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupItems()
    }
    
    private func updateFrame() {
        for (index, item) in items.enumerated() {
            let frame = getFrame(index: index)
            item.frame = frame
        }
        setImageOrTintColor()
    }
    
    private func setupItems() {
        items.forEach { $0.removeFromSuperview() }
        items.removeAll()
        for i in 0 ..< numberOfPages {
            let itemFrame = getFrame(index: i)
            let item = UIImageView(frame: itemFrame)
            addSubview(item)
            items.append(item)
        }
        setImageOrTintColor()
    }
    
    private func setImageOrTintColor() {
        for (index, item) in items.enumerated() {
            let itemFrame = getFrame(index: index)
            if index == currentPage {
                item.image = currentDotImage
                item.backgroundColor = currentDotImage == nil ? currentPageIndicatorTintColor : UIColor.clear
                var cornerRadius = currentDotRadius == nil ? itemFrame.size.height/2 : currentDotRadius!
                cornerRadius = currentDotImage == nil ? itemFrame.size.height/2 : 0
                item.layer.cornerRadius = cornerRadius
            } else {
                item.image = dotImage
                item.backgroundColor = dotImage == nil ? pageIndicatorTintColor : UIColor.clear
                var cornerRadius = dotRadius == nil ? itemFrame.size.height/2 : dotRadius!
                cornerRadius = dotImage == nil ? itemFrame.size.height/2 : 0
                item.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    private func getFrame(index: Int) -> CGRect {
        let itemW = dotSize.width + spacing
        let currentSize = currentDotSize == nil ? dotSize : currentDotSize!
        let currentItemW = currentSize.width + spacing
        let totalWidth = itemW*CGFloat(numberOfPages-1) + currentItemW + spacing
        var orignX: CGFloat = 0
        switch alignment {
        case .center:
            orignX = (frame.size.width-totalWidth)/2 + spacing
        case .left:
            orignX = spacing
        case .right:
            orignX = frame.size.width-totalWidth + spacing
        }
        var x: CGFloat = 0
        if index <= currentPage {
            x = orignX + CGFloat(index)*itemW
        } else {
            x = orignX + CGFloat(index-1)*itemW + currentItemW
        }
        let width = index == currentPage ? currentSize.width : dotSize.width
        let height = index == currentPage ? currentSize.height : dotSize.height
        let y = (frame.size.height-height)/2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self { return nil }
        return hitView
    }
}
