//
//  TableViewCell.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/29.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    lazy var cycleView: ZCycleView = ZCycleView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cycleView)
        cycleView.setUrlsGroup(["http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg", "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg", "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png"])
        cycleView.timeInterval = 3
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        cycleView.frame = bounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
