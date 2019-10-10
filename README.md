# ZCycleView

A picture/text infinite-scroll library with UICollectionView, It can be very easy to help you make the banner you want

使用`UICollectionView`实现常见图片/文字无限轮播，支持自定义`pageControl`，自定义文字样式，以及轮播样式

![](https://img.shields.io/badge/support-swift%205%2B-green.svg)  ![](https://img.shields.io/badge/support-iOS%208%2B-blue.svg)  ![](https://img.shields.io/cocoapods/v/ZCycleView.svg?style=flat)

<img src="https://github.com/MQZHot/ZCycleView/raw/master/Picture/picture.gif">

## 使用方法

```swift
let cycleView = ZCycleView(frame: frame)
cycleView.placeholderImage = UIImage(named: "placeholder")
cycleView.setUrlsGroup(["http://...", "http://...", "http://..."])
cycleView.delegate = self
view.addSubview(cycleView)
```

#### 要显示网络图片，需要实现下面的代理方法。
***你可以选择自己喜欢的图片加载库进行显示图片，例如[Kingfisher](https://github.com/onevcat/Kingfisher)或者[SDWebImage](https://github.com/gsdios/SDCycleScrollView)***

```swift
func cycleViewConfigureDefaultCellImageUrl(_ cycleView: ZCycleView, imageView: UIImageView, imageUrl: String?, index: Int) {
    imageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage: cycleView.placeholderImage)
}
````

#### 显示本地图片，需要实现下面的代理方法

```
func cycleViewConfigureDefaultCellImage(_ cycleView: ZCycleView, imageView: UIImageView, image: UIImage?, index: Int) {
    imageView.image = image
}
```

#### 修改`pageControl`或者`label`的样式，你可以使用下面的代理方法

```
func cycleViewConfigureDefaultCellText(_ cycleView: ZCycleView, titleLabel: UILabel, index: Int) {
    titleLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    titleLabel.textColor = .white
    titleLabel.font = UIFont.systemFont(ofSize: 13)
}

func cycleViewConfigurePageControl(_ cycleView: ZCycleView, pageControl: ZPageControl) {
    pageControl.pageIndicatorTintColor = UIColor.green
    pageControl.currentPageIndicatorTintColor = UIColor.red
}
```

#### 自定义cell样式

```
@objc optional func cycleViewCustomCellIdentifier() -> String
@objc optional func cycleViewCustomCellClass() -> AnyClass
@objc optional func cycleViewCustomCellClassNib() -> UINib
@objc optional func cycleViewCustomCellSetup(_ cycleView: ZCycleView, cell: UICollectionViewCell, for index: Int)
```

## 联系方式

* 邮箱: mqz1228@163.com

## LICENSE

ZCycleView is released under the MIT license. See [LICENSE](https://github.com/MQZHot/ZCycleView/blob/master/LICENSE) for details.
