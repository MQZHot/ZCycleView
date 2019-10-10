//
//  ZCycleView.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/17.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

@objc public protocol ZCycleViewProtocol: class {
    /// 配置默认的cell,
    /// 如果使用默认的cell显示图片，必须实现`cycleViewConfigureDefaultCellImage`或`cycleViewConfigureDefaultCellImageUrl`
    @objc optional func cycleViewConfigureDefaultCellImage(_ cycleView: ZCycleView, imageView: UIImageView, image: UIImage?, index: Int)
    @objc optional func cycleViewConfigureDefaultCellImageUrl(_ cycleView: ZCycleView, imageView: UIImageView, imageUrl: String?, index: Int)
    @objc optional func cycleViewConfigureDefaultCellText(_ cycleView: ZCycleView, titleLabel: UILabel, index: Int)
    /// 滚动到第index个cell
    @objc optional func cycleViewDidScrollToIndex(_ cycleView: ZCycleView, index: Int)
    /// 点击了第index个cell
    @objc optional func cycleViewDidSelectedIndex(_ cycleView: ZCycleView, index: Int)
    /// 自定义cell
    @objc optional func customCollectionViewCellIdentifier() -> String
    @objc optional func customCollectionViewCellClassForCycleScrollView() -> AnyClass
    @objc optional func customCollectionViewCellNibForCycleScrollView() -> UINib
    @objc optional func setupCustomCell(_ cell: UICollectionViewCell, for index: NSInteger, cycleView: ZCycleView)
}

public class ZCycleView: UIView {
    /// 设置本地图片
    /// - Parameter imagesGroup: image数组
    /// - Parameter titlesGroup: 标题数组
    public func setImagesGroup(_ imagesGroup: Array<UIImage?>,
                               titlesGroup: Array<String?>? = nil) {
        if imagesGroup.count == 0 { return }
        realDataCount = imagesGroup.count
        self.imagesGroup = imagesGroup
        self.titlesGroup = titlesGroup ?? []
        self.imageUrlsGroup = []
        reload()
    }
    
    /// 设置网络图片
    /// - Parameter urlsGroup: url数组
    /// - Parameter titlesGroup: 标题数组
    public func setUrlsGroup(_ urlsGroup: Array<String?>,
                             titlesGroup: Array<String?>? = nil) {
        if urlsGroup.count == 0 { return }
        realDataCount = urlsGroup.count
        self.imageUrlsGroup = urlsGroup
        self.titlesGroup = titlesGroup ?? []
        self.imagesGroup = []
        reload()
    }
    
    /// 设置文字
    /// - Parameter titlesGroup: 文字数组
    public func setTitlesGroup(_ titlesGroup: Array<String?>) {
        if titlesGroup.count == 0 { return }
        realDataCount = titlesGroup.count
        self.imagesGroup = []
        self.imageUrlsGroup = []
        self.titlesGroup = titlesGroup
        reload()
    }
    /// cell identifier
    /// add by LeeYZ
    private var reuseIdentifier: String = "ZCycleViewCell"
    
    /// 是否自动滚动
    public var isAutomatic: Bool = true
    /// 是否无限轮播
    public var isInfinite: Bool = true {
        didSet {
            if isInfinite == false {
                itemsCount = realDataCount <= 1 || !isInfinite ? realDataCount : realDataCount*200
                collectionView.reloadData()
                collectionView.setContentOffset(.zero, animated: false)
                dealFirstPage()
            }
        }
    }
    /// 滚动时间间隔，默认2s
    public var timeInterval: Int = 2
    /// 滚动方向
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet { flowLayout.scrollDirection = scrollDirection }
    }
    /// 占位图
    public var placeholderImage: UIImage? = nil {
        didSet { placeholderImgView.image = placeholderImage }
    }
    /// item大小，默认ZCycleView大小
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
    
    // MARK: - PageControl setting
    
    /// Whether to hide pageControl, the default `false`
    public var pageControlIsHidden = false {
        didSet { pageControl.isHidden = pageControlIsHidden }
    }
    /// Dot color, the default `gray`
    public var pageControlIndictirColor = UIColor.gray {
        didSet { pageControl.pageIndicatorTintColor = pageControlIndictirColor }
    }
    /// Current dot color, the default `white`
    public var pageControlCurrentIndictirColor = UIColor.white {
        didSet { pageControl.currentPageIndicatorTintColor = pageControlCurrentIndictirColor }
    }
    /// The current dot image
    public var pageControlCurrentIndictorImage: UIImage? {
        didSet { pageControl.currentDotImage = pageControlCurrentIndictorImage }
    }
    /// The dot image
    public var pageControlIndictorImage: UIImage? {
        didSet { pageControl.dotImage = pageControlIndictorImage }
    }
    /// The height of pageControl, default `25`
    public var pageControlHeight: CGFloat = 25 {
        didSet {
            pageControl.frame = CGRect(x: 0, y: frame.size.height-pageControlHeight, width: frame.size.width, height: pageControlHeight)
//            pageControl.updateFrame()
        }
    }
    /// PageControl's backgroundColor
    public var pageControlBackgroundColor = UIColor.clear {
        didSet { pageControl.backgroundColor = pageControlBackgroundColor }
    }
    /// The size of all dots
    public var pageControlItemSize = CGSize(width: 8, height: 8) {
        didSet { pageControl.dotSize = pageControlItemSize }
    }
    /// The size of current dot
    public var pageControlCurrentItemSize: CGSize? {
        didSet { pageControl.currentDotSize = pageControlCurrentItemSize }
    }
    /// The space of dot
    public var pageControlSpacing: CGFloat = 8 {
        didSet { pageControl.spacing = pageControlSpacing }
    }
    /// pageControl Alignment, left/right/center , default `center`
    public var pageControlAlignment: ZPageControlAlignment = .center {
        didSet { pageControl.alignment = pageControlAlignment }
    }
    /// the radius of dot
    public var pageControlItemRadius: CGFloat? {
        didSet { pageControl.dotRadius = pageControlItemRadius }
    }
    /// the radius of current dot
    public var pageControlCurrentItemRadius: CGFloat? {
        didSet { pageControl.currentDotRadius = pageControlCurrentItemRadius }
    }
    
    // MARK: - closure
    // Click and scroll events are in the form of closures  ---- add by LeeYZ
    /// delegate
    public weak var delegate: ZCycleViewProtocol? {
        didSet {
            if delegate != nil { registerCell() }
        }
    }
    
    //=============================================
    private var flowLayout: ZCycleLayout!
    private var collectionView: UICollectionView!
    private var placeholderImgView: UIImageView!
    private var pageControl: ZPageControl!
    private var imagesGroup: Array<UIImage?> = []
    private var imageUrlsGroup: Array<String?> = []
    private var titlesGroup: Array<String?> = []
    private var timer: Timer?
    private var itemsCount: Int = 0
    private var realDataCount: Int = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addPlaceholderImgView()
        addCollectionView()
        addPageControl()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addPlaceholderImgView()
        addCollectionView()
        addPageControl()
    }
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            self.startTimer()
        } else {
            self.cancelTimer()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = itemSize != nil ? itemSize! : bounds.size
        collectionView.frame = bounds
        pageControl.frame = CGRect(x: 0, y: frame.size.height-pageControlHeight, width: frame.size.width, height: pageControlHeight)
        collectionView.setContentOffset(.zero, animated: false)
        dealFirstPage()
    }
}

// MARK: - setupUI
extension ZCycleView {
    private func addPlaceholderImgView() {
        placeholderImgView = UIImageView(frame: CGRect.zero)
        placeholderImgView.image = placeholderImage
        addSubview(placeholderImgView)
        placeholderImgView.translatesAutoresizingMaskIntoConstraints = false
        let hCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|[placeholderImgView]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["placeholderImgView": placeholderImgView!])
        let vCons = NSLayoutConstraint.constraints(withVisualFormat: "V:|[placeholderImgView]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["placeholderImgView": placeholderImgView!])
        addConstraints(hCons)
        addConstraints(vCons)
    }
    
    private func addCollectionView() {
        flowLayout                                    = ZCycleLayout()
        flowLayout.itemSize                           = itemSize != nil ? itemSize! : bounds.size
        flowLayout.minimumInteritemSpacing            = 10000
        flowLayout.minimumLineSpacing                 = itemSpacing
        flowLayout.scrollDirection                    = scrollDirection
        
        collectionView                                = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor                = UIColor.clear
        collectionView.bounces                        = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate                       = self
        collectionView.dataSource                     = self
        collectionView.scrollsToTop                   = false
        collectionView.decelerationRate               = UIScrollView.DecelerationRate(rawValue: 0.0)
        registerCell()
        addSubview(collectionView)
    }
    
    /// add by LeeYZ
    private func registerCell() {
        if let customReuseIdentifier = delegate?.customCollectionViewCellIdentifier?() {
            self.reuseIdentifier = customReuseIdentifier
        }
        if let customClass = delegate?.customCollectionViewCellClassForCycleScrollView?() {
            collectionView.register(customClass, forCellWithReuseIdentifier: reuseIdentifier)
        } else if let customNib = delegate?.customCollectionViewCellNibForCycleScrollView?() {
            collectionView.register(customNib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            collectionView.register(ZCycleViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    private func addPageControl() {
        pageControl = ZPageControl(frame: CGRect(x: 0, y: bounds.size.height - pageControlHeight, width: bounds.size.width, height: pageControlHeight))
        addSubview(pageControl)
    }
    
    private func reload() {
        placeholderImgView.isHidden = true
        itemsCount = realDataCount <= 1 || !isInfinite ? realDataCount : realDataCount*200
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
        dealFirstPage()
        pageControl.numberOfPages = realDataCount
        pageControl.isHidden = realDataCount == 1 || (imagesGroup.count == 0 && imageUrlsGroup.count == 0)
        pageControl.currentPage = currentIndex() % realDataCount
        if isAutomatic { startTimer() }
    }
}

// MARK: - UICollectionViewDataSource / UICollectionViewDelegate
extension ZCycleView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cycleCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let index = indexPath.item % realDataCount
        
        if self.delegate?.setupCustomCell?(cycleCell, for: index, cycleView: self) != nil {
            return cycleCell
        }
        /// 使用默认的cell
        guard let cell = cycleCell as? ZCycleViewCell else { return cycleCell }
        cell.onlyText = imagesGroup.count == 0 && imageUrlsGroup.count == 0
        let title = index < titlesGroup.count ? titlesGroup[index] : nil
        cell.titleLabel.text = title
        if imagesGroup.count != 0 {
            let image = index < imagesGroup.count ? imagesGroup[index] : nil
            delegate?.cycleViewConfigureDefaultCellImage?(self, imageView: cell.imageView, image: image, index: index)
            if delegate?.cycleViewConfigureDefaultCellImage?(self, imageView: cell.imageView, image: image, index: index) == nil {
                NSException(name: .init(rawValue: "ZCycleViewError"), reason: "cycleViewConfigureDefaultCellImage方法未实现", userInfo: nil).raise()
            }
        }
        if imageUrlsGroup.count != 0 {
            let imageUrl = index < imageUrlsGroup.count ? imageUrlsGroup[index] : nil
            delegate?.cycleViewConfigureDefaultCellImageUrl?(self, imageView: cell.imageView, imageUrl: imageUrl, index: index)
            if delegate?.cycleViewConfigureDefaultCellImageUrl?(self, imageView: cell.imageView, imageUrl: imageUrl, index: index) == nil {
                NSException(name: .init(rawValue: "ZCycleViewError"), reason: "cycleViewConfigureDefaultCellImageUrl方法未实现", userInfo: nil).raise()
            }
        }
        delegate?.cycleViewConfigureDefaultCellText?(self, titleLabel: cell.titleLabel, index: index)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let centerViewPoint = convert(collectionView.center, to: collectionView)
        guard let centerIndex = collectionView.indexPathForItem(at: centerViewPoint) else { return }
        if indexPath.item == centerIndex.item {
            let index = indexPath.item % realDataCount
            if let delegate = delegate { delegate.cycleViewDidSelectedIndex?(self, index: index) }
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
        let index = currentIndex() % realDataCount
        pageControl?.currentPage = index
        delegate.cycleViewDidScrollToIndex?(self, index: index)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl?.currentPage = currentIndex() % realDataCount
    }
}

// MARK: - 处理第一帧和最后一帧
extension ZCycleView {
    private func dealFirstPage() {
        if currentIndex() == 0 && itemsCount > 1 && isInfinite {
            let targetIndex = itemsCount / 2
            let scrollPosition: UICollectionView.ScrollPosition = scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: false)
        }
    }
    private func dealLastPage() {
        if currentIndex() == itemsCount-1 && itemsCount > 1 && isInfinite {
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
        timer = Timer.init(timeInterval: Double(timeInterval), target: self, selector: #selector(timeRepeat), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    private func cancelTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func timeRepeat() {
        let current = currentIndex()
        var targetIndex = current + 1
        if (current == itemsCount - 1) {
            if isInfinite == false {return}
            dealLastPage()
            targetIndex = itemsCount / 2
        }
        let scrollPosition: UICollectionView.ScrollPosition = scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: true)
    }
    
    private func currentIndex() -> Int {
        let itemWH = scrollDirection == .horizontal ? flowLayout.itemSize.width+itemSpacing : flowLayout.itemSize.height+itemSpacing
        let offsetXY = scrollDirection == .horizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        if itemWH == 0 { return 0 }
        let index = round(offsetXY / itemWH)
        return Int(index)
    }
}
