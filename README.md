# ZCycleView

A picture/text infinite-scroll library with UICollectionView, It can be very easy to help you make the banner you want

使用`UICollectionView`实现常见图片/文字无限轮播，支持自定义`pageControl`，自定义文字样式，以及轮播样式

![image](https://travis-ci.org/MQZHot/ZCycleView.svg?branch=master)   ![](https://img.shields.io/badge/support-swift%204%2B-green.svg)  ![](https://img.shields.io/badge/support-iOS%208%2B-blue.svg)  ![](https://img.shields.io/cocoapods/v/ZCycleView.svg?style=flat)

<img src="https://github.com/MQZHot/ZCycleView/raw/master/Picture/picture.gif">

## How To

#### Basic usage

pretty easy to use，Basic usage like this
```swift
let cycleView = ZCycleView(frame: frame)
cycleView.placeholderImage = UIImage(named: "placeholder")
cycleView.setUrlsGroup(["http://...", "http://...", "http://..."], titlesGroup: ["...", "..."])
view.addSubview(cycleView)
```

#### Set  image or image url or text

you can also set the desc `titlesGroup` or `attributedTitlesGroup`, pick one of two, `attributedTitlesGroup` first
```swift
/// image
func setImagesGroup(_ imagesGroup: Array<UIImage?>, titlesGroup: [String?]? = nil, attributedTitlesGroup: [NSAttributedString?]? = nil)
/// image url
func setUrlsGroup(_ urlsGroup: Array<String>, titlesGroup: [String?]? = nil, attributedTitlesGroup: [NSAttributedString?]? = nil)
/// text only
func setTitlesGroup(_ titlesGroup: Array<String?>?, attributedTitlesGroup: [NSAttributedString?]? = nil)
````
If you want the effect in the picture below, use the following method

***Special reminder, be sure to set the size, otherwise the picture does not display***

<img src="https://github.com/MQZHot/ZCycleView/raw/master/Picture/pic1.png">

```swift
func setTitleImagesGroup(_ titleImagesGroup: [UIImage?], sizeGroup:[CGSize?])
func setTitleImageUrlsGroup(_ titleImageUrlsGroup: [String?], sizeGroup:[CGSize?])
```
#### About item settings
```swift
/// The size of the item, the default cycleView size
var itemSize: CGSize?
/// The scale of the center item
var itemZoomScale: CGFloat = 1
/// The space of items
var itemSpacing: CGFloat = 0
/// corner radius
var itemCornerRadius: CGFloat = 0
/// item borderColor
var itemBorderColor: UIColor = UIColor.clear
/// item borderWidth
var itemBorderWidth: CGFloat = 0
```
E.g, Effect as shown below
```swift
cycleView.itemSize = CGSize(width: 240, height: 90)
cycleView.itemZoomScale = 1.2
```
<img src="https://github.com/MQZHot/ZCycleView/raw/master/Picture/pic2.png">

#### About desc settings

<img src="https://github.com/MQZHot/ZCycleView/raw/master/Picture/pic5.png">

<img src="https://github.com/MQZHot/ZCycleView/raw/master/Picture/pic6.png">

```swift
/// The height of the desc containerView, if you set the left image, is also included
var titleViewHeight: CGFloat = 25
/// titleAlignment
public var titleAlignment: NSTextAlignment = .left
/// desc font
public var titleFont: UIFont = UIFont.systemFont(ofSize: 13)
/// The backgroundColor of the desc containerView
public var titleBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
/// titleColor
public var titleColor: UIColor = UIColor.white
/// The number of lines of text displayed
public var titleNumberOfLines = 1
/// The breakMode of lines of text displayed
public var titleLineBreakMode: NSLineBreakMode = .byWordWrapping
```
#### About pageControl settings

<img src="https://github.com/MQZHot/ZCycleView/raw/master/Picture/pic3.png">

<img src="https://github.com/MQZHot/ZCycleView/raw/master/Picture/pic4.png">

```swift
/// Whether to hide pageControl, the default `false`
var pageControlIsHidden = false
/// Dot color, the default `gray`
var pageControlIndictirColor = UIColor.gray
/// Current dot color, the default `white`
var pageControlCurrentIndictirColor = UIColor.white
/// The current dot image
var pageControlCurrentIndictorImage: UIImage?
/// The dot image
var pageControlIndictorImage: UIImage?
/// The height of pageControl, default `25`
var pageControlHeight: CGFloat = 25
/// PageControl's backgroundColor
var pageControlBackgroundColor = UIColor.clear
/// The size of all dots
var pageControlItemSize = CGSize(width: 8, height: 8)
/// The size of current dot
var pageControlCurrentItemSize: CGSize?
/// The space of dot
var pageControlSpacing: CGFloat = 8
/// pageControl Alignment, left/right/center , default `center`
var pageControlAlignment: ZCyclePageControlAlignment = .center
/// the radius of dot
var pageControlItemRadius: CGFloat?
/// the radius of current dot
var pageControlCurrentItemRadius: CGFloat?
```

#### didSelectedItem, didScrollToIndex
Click and scroll events are in the form of closures or delegate

```swift
/// scrollToIndex
func cycleViewDidScrollToIndex(_ index: Int)

/// selectedIndex
func cycleViewDidSelectedIndex(_ index: Int)
```

```swift
/// click
var didSelectedItem: ((Int)->())?
/// scroll
var didScrollToIndex: ((Int)->())?
```

#### Other prototype
```swift
/// isAutomatic
var isAutomatic: Bool = true
/// isInfinite
var isInfinite: Bool = true
/// scroll timeInterval
var timeInterval: Int = 2
/// scrollDirection
var scrollDirection: UICollectionViewScrollDirection = .horizontal
/// placeholderImage
var placeholderImage: UIImage? = nil
```

## dependency

[Kingfisher](https://github.com/onevcat/Kingfisher)

## Contact

* Email: mqz1228@163.com

## LICENSE

ZCycleView is released under the MIT license. See [LICENSE](https://github.com/MQZHot/ZCycleView/blob/master/LICENSE) for details.
