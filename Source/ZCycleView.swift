//
//  ZCycleView.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/17.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

@objc public protocol ZCycleViewProtocol: class {
    @objc func cycleViewRegisterCellClasses() -> [String: AnyClass]
    @objc func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell
    /// 滚动到第index个cell
    @objc optional func cycleViewDidScrollToIndex(_ cycleView: ZCycleView, index: Int)
    /// 点击了第index个cell
    @objc optional func cycleViewDidSelectedIndex(_ cycleView: ZCycleView, index: Int)
    /// pageControl设置
    @objc optional func cycleViewConfigurePageControl(_ cycleView: ZCycleView, pageControl: ZPageControl)
}

public class ZCycleView: UIView {
    public var currentIndex: Int { return getCurrentIndex() }
    public var currentCell: UICollectionViewCell? {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        return collectionView.cellForItem(at: indexPath)
    }

    /// 滚动时间间隔，默认2s
    public var timeInterval: Int = 3
    /// 是否自动滚动
    public var isAutomatic: Bool = true
    /// 是否无限轮播
    public var isInfinite: Bool = true {
        didSet {
            if isInfinite == false {
                itemsCount = realItemsCount <= 1 || !isInfinite ? realItemsCount : realItemsCount*200
                collectionView.reloadData()
                collectionView.setContentOffset(.zero, animated: false)
                dealFirstPage()
            }
        }
    }
    
    /// 滚动方向
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet { flowLayout.scrollDirection = scrollDirection }
    }

    /// 占位图
    public var placeholderImage: UIImage? {
        didSet { placeholder.image = placeholderImage }
    }

    /// item大小
    public var itemSize: CGSize? {
        didSet {
            guard let itemSize = itemSize else { return }
            let width = min(bounds.size.width, itemSize.width)
            let height = min(bounds.size.height, itemSize.height)
            flowLayout.itemSize = CGSize(width: width, height: height)
        }
    }

    /// 中间item的放大比例, >=1
    public var itemZoomScale: CGFloat = 1 {
        didSet {
            collectionView.isPagingEnabled = itemZoomScale == 1
            flowLayout.scale = itemZoomScale
        }
    }

    /// item 间距
    public var itemSpacing: CGFloat = 0 {
        didSet { flowLayout.minimumLineSpacing = itemSpacing }
    }
    
    /// delegate
    public weak var delegate: ZCycleViewProtocol? {
        didSet {
            guard let delegate = delegate else { return }
            let cellClasses = delegate.cycleViewRegisterCellClasses()
            if cellClasses.count > 0 {
                cellClasses.forEach {
                    let cellClass = $0.value as! UICollectionViewCell.Type
                    collectionView.register(cellClass.self, forCellWithReuseIdentifier: $0.key)
                }
            } else {
                fatalError("cell注册错误")
            }
        }
    }
    
    public func reloadItems(with count: Int) {
        realItemsCount = count
        reload()
    }
    
    // MARK: - Private

    private lazy var flowLayout: ZCycleLayout = {
        let layout = ZCycleLayout()
        layout.minimumInteritemSpacing = 10000
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = scrollDirection
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.0)
        return collectionView
    }()
    
    private lazy var placeholder = UIImageView()
    private var pageControl: ZPageControl!
    
    private var timer: Timer?
    private var itemsCount: Int = 0
    private var realItemsCount: Int = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupPlaceholder()
        setupCollectionView()
        setupPageControl()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPlaceholder()
        setupCollectionView()
        setupPageControl()
    }
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            startTimer()
        } else {
            cancelTimer()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = itemSize != nil ? itemSize! : bounds.size
        pageControl.frame = CGRect(x: 0, y: frame.size.height - 25, width: frame.size.width, height: 25)
        collectionView.setContentOffset(.zero, animated: false)
        dealFirstPage()
        delegate?.cycleViewConfigurePageControl?(self, pageControl: pageControl)
    }
}

// MARK: - UI

extension ZCycleView {
    private func setupPlaceholder() {
        addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        let hCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|[placeholder]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["placeholder": placeholder])
        let vCons = NSLayoutConstraint.constraints(withVisualFormat: "V:|[placeholder]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["placeholder": placeholder])
        addConstraints(hCons)
        addConstraints(vCons)
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let hCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["collectionView": collectionView])
        let vCons = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["collectionView": collectionView])
        addConstraints(hCons)
        addConstraints(vCons)
    }
    
    private func setupPageControl() {
        pageControl = ZPageControl()
        addSubview(pageControl)
    }
    
    private func reload() {
        placeholder.isHidden = true
        itemsCount = realItemsCount <= 1 || !isInfinite ? realItemsCount : realItemsCount*200
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
        dealFirstPage()
        if isAutomatic { startTimer() }
        if pageControl.isHidden { return }
        pageControl.numberOfPages = realItemsCount
        pageControl.isHidden = realItemsCount == 1
        pageControl.currentPage = getCurrentIndex() % realItemsCount
    }
}

// MARK: - UICollectionViewDataSource / UICollectionViewDelegate

extension ZCycleView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item % realItemsCount
        return delegate?.cycleViewConfigureCell(collectionView: collectionView, cellForItemAt: indexPath, realIndex: index) ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let centerViewPoint = convert(collectionView.center, to: collectionView)
        guard let centerIndex = collectionView.indexPathForItem(at: centerViewPoint) else { return }
        if indexPath.item == centerIndex.item {
            let index = indexPath.item % realItemsCount
            delegate?.cycleViewDidSelectedIndex?(self, index: index)
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ZCycleView {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAutomatic { cancelTimer() }
        dealLastPage()
        dealFirstPage()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutomatic { startTimer() }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let delegate = delegate else { return }
        let index = getCurrentIndex() % realItemsCount
        pageControl?.currentPage = index
        delegate.cycleViewDidScrollToIndex?(self, index: index)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl?.currentPage = getCurrentIndex() % realItemsCount
    }
}

// MARK: - 处理第一帧和最后一帧

extension ZCycleView {
    private func dealFirstPage() {
        if getCurrentIndex() == 0, itemsCount > 1, isInfinite {
            let targetIndex = itemsCount / 2
            let scrollPosition: UICollectionView.ScrollPosition = scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: false)
        }
    }

    private func dealLastPage() {
        if getCurrentIndex() == itemsCount - 1, itemsCount > 1, isInfinite {
            let targetIndex = itemsCount / 2 - 1
            let scrollPosition: UICollectionView.ScrollPosition = scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: false)
        }
    }
}

// MARK: - 定时器操作

extension ZCycleView {
    private func startTimer() {
        if !isAutomatic { return }
        if itemsCount <= 1 { return }
        cancelTimer()
        timer = Timer(timeInterval: Double(timeInterval), target: self, selector: #selector(timeRepeat), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    private func cancelTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func timeRepeat() {
        let current = getCurrentIndex()
        var targetIndex = current + 1
        if current == itemsCount - 1 {
            if isInfinite == false { return }
            dealLastPage()
            targetIndex = itemsCount / 2
        }
        let scrollPosition: UICollectionView.ScrollPosition = scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: true)
    }
    
    private func getCurrentIndex() -> Int {
        let itemWH = scrollDirection == .horizontal ? flowLayout.itemSize.width + itemSpacing : flowLayout.itemSize.height + itemSpacing
        let offsetXY = scrollDirection == .horizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        if itemWH == 0 { return 0 }
        let index = round(offsetXY / itemWH)
        return Int(index)
    }
}
