# ZCycleView

使用`UICollectionView`实现常见图片轮播，支持自定义pageControl，自定义Cell

![](https://img.shields.io/badge/support-swift%205%2B-green.svg)  ![](https://img.shields.io/badge/support-iOS%209%2B-blue.svg)  ![](https://img.shields.io/cocoapods/v/ZCycleView.svg?style=flat)

<img src="https://github.com/MQZHot/ZCycleView/raw/master/Picture/picture.gif">

## 使用方法

```swift
let cycleView = ZCycleView()
cycleView.delegate = self
cycleView.reloadItemsCount(images.count)
cycleView.itemSpacing = 10
cycleView.itemSize = CGSize(width: width - 150, height: (width - 150) / 2.3333)
cycleView.initialIndex = 1
view.addSubview(cycleView)
```

#### 代理方法

```swift
protocol ZCycleViewProtocol: class {
    /// 注册cell，[重用标志符：cell类]
    func cycleViewRegisterCellClasses() -> [String: AnyClass]
    /// 配置cell
    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell
    /// 开始拖拽
    func cycleViewBeginDragingIndex(_ cycleView: ZCycleView, index: Int)
    /// 滚动到index
    func cycleViewDidScrollToIndex(_ cycleView: ZCycleView, index: Int)
    /// 点击了index
    func cycleViewDidSelectedIndex(_ cycleView: ZCycleView, index: Int)
    /// 自定义pageControl
    func cycleViewConfigurePageControl(_ cycleView: ZCycleView, pageControl: ZPageControl)
}
````
