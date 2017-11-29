//
//  ZCycleView.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/17.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

public class ZCycleView: UIView {
    
    /// 是否自动滚动
    public var isAutomatic: Bool = true
    /// 是否无限循环
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
    /// 滚动时间
    public var timeInterval: Int = 2
    /// 滚动方向
    public var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet { flowLayout.scrollDirection = scrollDirection }
    }
    /// 占位图
    public var placeholderImage: UIImage? = nil {
        didSet { placeholderImgView.image = placeholderImage }
    }
    
// MARK: - 轮播设置 -------------------------------
    /// 图片轮播 --- 设置图片
    public func setImagesGroup(_ imagesGroup: Array<UIImage?>, titlesGroup: [String?]? = nil, attributedTitlesGroup: [NSAttributedString?]? = nil) {
        if imagesGroup.count == 0 { return }
        resourceType = .image
        realDataCount = imagesGroup.count
        self.imagesGroup = imagesGroup
        setResource(titlesGroup, attributedTitlesGroup: attributedTitlesGroup)
    }
    /// 图片轮播 --- 设置url
    public func setUrlsGroup(_ urlsGroup: Array<String>, titlesGroup: [String?]? = nil, attributedTitlesGroup: [NSAttributedString?]? = nil) {
        if urlsGroup.count == 0 { return }
        resourceType = .imageURL
        realDataCount = urlsGroup.count
        self.imageUrlsGroup = urlsGroup
        setResource(titlesGroup, attributedTitlesGroup: attributedTitlesGroup)
    }
    /// 文字轮播
    public func setTitlesGroup(_ titlesGroup: Array<String?>?, attributedTitlesGroup: [NSAttributedString?]? = nil) {
        if attributedTitlesGroup == nil && titlesGroup == nil { return }
        resourceType = .text
        if attributedTitlesGroup != nil {
            if attributedTitlesGroup!.count == 0 { return }
            realDataCount = attributedTitlesGroup!.count
        } else {
            if titlesGroup!.count == 0 { return }
            realDataCount = titlesGroup!.count
        }
        setResource(titlesGroup, attributedTitlesGroup: attributedTitlesGroup)
    }
    /// 设置文字左侧图片 大小
    public func setTitleImagesGroup(_ titleImagesGroup: [UIImage?], sizeGroup:[CGSize?]) {
        self.titleImagesGroup = titleImagesGroup
        self.titleImageSizeGroup = sizeGroup
        collectionView.reloadData()
    }
    /// 设置文字左侧图片url 大小
    public func setTitleImageUrlsGroup(_ titleImageUrlsGroup: [String?], sizeGroup:[CGSize?]) {
        self.titleImageUrlsGroup = titleImageUrlsGroup
        self.titleImageSizeGroup = sizeGroup
        collectionView.reloadData()
    }
// MARK: - item setting
    /// item大小
    public var itemSize: CGSize? {
        didSet {
            if resourceType == .text { return }
            if let itemSize = itemSize {
                let width = min(bounds.size.width, itemSize.width)
                let height = min(bounds.size.height, itemSize.height)
                flowLayout.itemSize = CGSize(width: width, height: height)
            }
        }
    }
    /// 中间item的放大比例， 建议大于 1
    public var itemZoomScale: CGFloat = 1 {
        didSet {
            if resourceType == .text { return }
            flowLayout.scale = itemZoomScale
        }
    }
    /// item 间距
    public var itemSpacing: CGFloat = 0 {
        didSet {
            if resourceType == .text { itemSpacing = 0; return }
            flowLayout.minimumLineSpacing = itemSpacing
        }
    }
    /// item 圆角
    public var itemCornerRadius: CGFloat = 0
    /// item 边框颜色
    public var itemBorderColor: UIColor = UIColor.clear
    /// item 边框宽度
    public var itemBorderWidth: CGFloat = 0
    
// MARK: - imageView Setting 图片设置 -------------------------------
    /// 图片填充方式
    public var imageContentMode: UIViewContentMode = .scaleToFill
    
// MARK: - titleLabel setting 文字设置 -------------------------------
    public var titleViewHeight: CGFloat = 25
    /// title 对齐方式
    public var titleAlignment: NSTextAlignment = .left 
    /// title 字体
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 13)
    /// title 背景颜色
    public var titleBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    /// title 字体颜色
    public var titleColor: UIColor = UIColor.white
    /// title 显示行数
    public var titleNumberOfLines = 1
    /// title 断行方式
    public var titleLineBreakMode: NSLineBreakMode = .byWordWrapping
    
// MARK: - PageControl 设置 -----------------------
    /// 隐藏pageControl
    public var pageControlIsHidden = false {
        didSet { pageControl.isHidden = pageControlIsHidden }
    }
    /// 小圆点颜色
    public var pageControlIndictirColor = UIColor.gray {
        didSet { pageControl.pageIndicatorTintColor = pageControlIndictirColor }
    }
    /// 当前小圆点颜色
    public var pageControlCurrentIndictirColor = UIColor.white {
        didSet { pageControl.currentPageIndicatorTintColor = pageControlCurrentIndictirColor }
    }
    /// 当前图片
    public var pageControlCurrentIndictorImage: UIImage? {
        didSet { pageControl.currentItemImage = pageControlCurrentIndictorImage }
    }
    /// 其他图片
    public var pageControlIndictorImage: UIImage? {
        didSet { pageControl.itemImage = pageControlIndictorImage }
    }
    /// pageControl高度
    public var pageControlHeight: CGFloat = 25 {
        didSet {
            pageControl.frame = CGRect(x: 0, y: frame.size.height-pageControlHeight, width: frame.size.width, height: pageControlHeight)
            pageControl.updateFrame()
        }
    }
    /// 背景颜色
    public var pageControlBackgroundColor = UIColor.clear {
        didSet { pageControl.backgroundColor = pageControlBackgroundColor }
    }
    /// 圆点大小
    public var pageControlItemSize = CGSize(width: 8, height: 8) {
        didSet { pageControl.controlSize = pageControlItemSize }
    }
    /// 当前圆点大小
    public var pageControlCurrentItemSize: CGSize? {
        didSet { pageControl.currentControlSize = pageControlCurrentItemSize }
    }
    /// 圆点间距
    public var pageControlSpacing: CGFloat = 8 {
        didSet { pageControl.controlSpacing = pageControlSpacing }
    }
    /// 对齐方式
    public var pageControlAlignment: ZCyclePageControlAlignment = .center {
        didSet { pageControl.alignment = pageControlAlignment }
    }
    /// 圆角
    public var pageControlItemRadius: CGFloat? {
        didSet { pageControl.itemCornerRadius = pageControlItemRadius }
    }
    /// 当前圆角
    public var pageControlCurrentItemRadius: CGFloat? {
        didSet { pageControl.currentItemCornerRadius = pageControlCurrentItemRadius }
    }
    
// MARK: - 闭包 -----------------------------------
    /// 点击了item
    public var didSelectedItem: ((Int)->())?
    /// 滚动到某一位置
    public var didScrollToIndex: ((Int)->())?
    // --- end ---------
    
    
    //=============================================
    fileprivate var flowLayout: ZCycleLayout!
    fileprivate var collectionView: UICollectionView!
    fileprivate var placeholderImgView: UIImageView!
    fileprivate var pageControl: ZCyclePageControl!
    fileprivate var imagesGroup: Array<UIImage?> = []
    fileprivate var imageUrlsGroup: Array<String> = []
    fileprivate var titlesGroup: [NSAttributedString?] = []
    fileprivate var titleImagesGroup: Array<UIImage?> = []
    fileprivate var titleImageUrlsGroup: Array<String?> = []
    fileprivate var titleImageSizeGroup: Array<CGSize?> = []
    fileprivate var timer: Timer?
    fileprivate var itemsCount: Int = 0
    fileprivate var realDataCount: Int = 0
    fileprivate var resourceType: ResourceType = .image
    override init(frame: CGRect) {
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
    private func addPlaceholderImgView() {
        placeholderImgView = UIImageView(frame: bounds)
        placeholderImgView.image = placeholderImage
        addSubview(placeholderImgView)
    }
    private func addCollectionView() {
        flowLayout = ZCycleLayout()
        flowLayout.itemSize = itemSize != nil ? itemSize! : bounds.size
        flowLayout.minimumInteritemSpacing = 10000
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.scrollDirection = scrollDirection
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.register(ZCycleViewCell.self, forCellWithReuseIdentifier: "ZCycleViewCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.decelerationRate = 0.0
        addSubview(collectionView)
        
    }
    private func addPageControl() {
        pageControl = ZCyclePageControl(frame: CGRect(x: 0, y: bounds.size.height - pageControlHeight, width: bounds.size.width, height: pageControlHeight))
        addSubview(pageControl)
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
        pageControl.updateFrame()
        
        collectionView.setContentOffset(.zero, animated: false)
        dealFirstPage()
    }
    
    private func setResource(_ titlesGroup: Array<String?>?, attributedTitlesGroup: [NSAttributedString?]?) {
        placeholderImgView.isHidden = true
        itemsCount = realDataCount <= 1 || !isInfinite ? realDataCount : realDataCount*200
        if attributedTitlesGroup != nil {
            self.titlesGroup = attributedTitlesGroup ?? []
        } else {
            let titles = titlesGroup?.map { return NSAttributedString(string: $0 ?? "") }
            self.titlesGroup = titles ?? []
        }
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
        dealFirstPage()
        pageControl.numberOfPages = realDataCount
        pageControl.currentPage = currentIndex() % realDataCount
        if resourceType == .text  {pageControl.isHidden = true}
        if isAutomatic { startTimer() }
    }
}

// MARK: - UICollectionViewDataSource/UICollectionViewDelegate
extension ZCycleView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZCycleViewCell", for: indexPath) as! ZCycleViewCell
        let index = indexPath.item % realDataCount
        switch resourceType {
        case .image:
            cell.imageView.image = imagesGroup[index]
        case .imageURL:
            cell.imageUrl(imageUrlsGroup[index], placeholder: placeholderImage)
        case .text:
            break
        }
        if resourceType != .text {
            cell.layer.borderWidth = itemBorderWidth
            cell.layer.borderColor = itemBorderColor.cgColor
            cell.layer.cornerRadius = itemCornerRadius
            cell.layer.masksToBounds = true
        }
/// --------------------title setting-----------------------  ///
        cell.titleContainerViewH = resourceType == .text ? collectionView.bounds.size.height : titleViewHeight
        cell.titleLabel.textAlignment = titleAlignment
        cell.titleContainerView.backgroundColor = titleBackgroundColor
        cell.titleLabel.font = titleFont
        cell.titleLabel.numberOfLines = titleNumberOfLines
        cell.titleLabel.textColor = titleColor
        let title = index < titlesGroup.count ? titlesGroup[index] : nil
        let titleImage = index < titleImagesGroup.count ? titleImagesGroup[index] : nil
        let titleImageUrl = index < titleImageUrlsGroup.count ? titleImageUrlsGroup[index] : nil
        let titleImageSize = index < titleImageSizeGroup.count ? titleImageSizeGroup[index] : nil
        cell.attributeString(title, titleImgURL: titleImageUrl, titleImage: titleImage, titleImageSize: titleImageSize)
/// --------------imgView setting----------------------------  ///
        cell.imageView.contentMode = imageContentMode
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let centerViewPoint = convert(collectionView.center, to: collectionView)
        if let centerIndex = collectionView.indexPathForItem(at: centerViewPoint) {
            if indexPath.item == centerIndex.item {
                let index = indexPath.item % realDataCount
                if didSelectedItem != nil {
                    didSelectedItem!(index)
                }
            } else {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
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
        let index = currentIndex() % realDataCount
        pageControl?.currentPage = index
        if didScrollToIndex != nil {
            didScrollToIndex!(index)
        }
    }
}

// MARK: - deal the first page and last page
extension ZCycleView {
    fileprivate func dealFirstPage() {
        if currentIndex() == 0 && itemsCount > 1 && isInfinite {
            let targetIndex = itemsCount / 2
            let scrollPosition: UICollectionViewScrollPosition = scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: false)
            if didScrollToIndex != nil {
                didScrollToIndex!(0)
            }
        }
    }
    fileprivate func dealLastPage() {
        if currentIndex() == itemsCount-1 && itemsCount > 1 && isInfinite {
            let targetIndex = itemsCount / 2 - 1
            let scrollPosition: UICollectionViewScrollPosition = scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: false)
        }
    }
}
// MARK: - timer
extension ZCycleView {
    fileprivate func startTimer() {
        if !isAutomatic { return }
        if itemsCount <= 1 { return }
        cancelTimer()
        timer = Timer.init(timeInterval: Double(timeInterval), target: self, selector: #selector(timeRepeat), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    fileprivate func cancelTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func timeRepeat() {
        let current = currentIndex()
        var targetIndex = current + 1
        if (current == itemsCount - 1) {
            if isInfinite == false {return}
            dealLastPage()
            targetIndex = itemsCount / 2
        }
        let scrollPosition: UICollectionViewScrollPosition = scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: scrollPosition, animated: true)
    }
    fileprivate func currentIndex() -> Int {
        let itemWH = scrollDirection == .horizontal ? flowLayout.itemSize.width+itemSpacing : flowLayout.itemSize.height+itemSpacing
        let offsetXY = scrollDirection == .horizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        // contentOffset changes /(ㄒoㄒ)/~~ ??????????
        if itemWH == 0 { return 0 }
        let index = round(offsetXY / itemWH)
        return Int(index)
    }
}
