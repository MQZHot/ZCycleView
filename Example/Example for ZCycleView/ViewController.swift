//
//  ViewController.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/18.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import SDWebImage
import SnapKit
import UIKit
import ZCycleView

let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
//    let urls = ["http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg",
//                "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg",
//                "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png"]

    let images = [UIImage(named: "p700-300-1"),
                  UIImage(named: "p700-300-2"),
                  UIImage(named: "p700-300-3"),
                  UIImage(named: "p700-300-4"),
                  UIImage(named: "p700-300-5")]
    
    private lazy var cycleView1: ZCycleView = {
        let width = view.bounds.width - 20
        let cycleView1 = ZCycleView()
        cycleView1.placeholderImage = #imageLiteral(resourceName: "placeholder")
        cycleView1.scrollDirection = .horizontal
        cycleView1.delegate = self
        cycleView1.reloadItemsCount(images.count)
        cycleView1.itemZoomScale = 1.2
        cycleView1.itemSpacing = 10
        cycleView1.initialIndex = 1
        cycleView1.isAutomatic = false
//        cycleView1.isInfinite = false
        cycleView1.itemSize = CGSize(width: width - 150, height: (width - 150) / 2.3333)
        return cycleView1
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cycleView1)
        cycleView1.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.top.equalTo(100)
            $0.right.equalTo(-10)
            $0.height.equalTo(cycleView1.snp.width).dividedBy(2.3333)
        }
    }
}

extension ViewController: ZCycleViewProtocol {
    func cycleViewRegisterCellClasses() -> [String: AnyClass] {
        return ["CustomCollectionViewCell": CustomCollectionViewCell.self]
    }

    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.imageView.image = images[realIndex]
        return cell
    }
    
    func cycleViewDidScrollToIndex(_ cycleView: ZCycleView, index: Int) {
        
    }
    
    func cycleViewConfigurePageControl(_ cycleView: ZCycleView, pageControl: ZPageControl) {
        pageControl.isHidden = false
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .green
        pageControl.frame = CGRect(x: 0, y: cycleView.bounds.height-25, width: cycleView.bounds.width, height: 25)
    }
}
