//
//  ViewController.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/18.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import SDWebImage
import UIKit
import ZCycleView
import SnapKit
let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    let urls = ["http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg",
                "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg",
                "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png"]

    var cycleView1: ZCycleView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.bounds.width - 20
        cycleView1 = ZCycleView()
//        cycleView1.frame = CGRect(x: 10, y: 100, width: width, height: width / 5)
        cycleView1.placeholderImage = #imageLiteral(resourceName: "placeholder")
        cycleView1.scrollDirection = .horizontal
        cycleView1.delegate = self
        cycleView1.reloadItems(with: urls.count)
        cycleView1.itemZoomScale = 1.2
        cycleView1.itemSpacing = 20
        cycleView1.itemSize = CGSize(width: width-150, height: (width-150)/5)
        view.addSubview(cycleView1)
        cycleView1.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.top.equalTo(100)
            $0.right.equalTo(-10)
            $0.height.equalTo(cycleView1.snp.width).dividedBy(5)
        }
    }
}

extension ViewController: ZCycleViewProtocol {
    func cycleViewRegisterCellClasses() -> [String: AnyClass] {
        return ["CustomCollectionViewCell": CustomCollectionViewCell.self]
    }

    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.imageView.sd_setImage(with: URL(string: urls[realIndex]))
        return cell
    }
}
