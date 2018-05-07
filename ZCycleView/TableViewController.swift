//
//  TableViewController.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/29.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cycleView = ZCycleView(frame: CGRect(x: 0, y: 0, width: width, height: width*240/640))
        cycleView.placeholderImage = #imageLiteral(resourceName: "placeholder")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            cycleView.setUrlsGroup(["http://t.cn/RYVfQep",
                                    "http://t.cn/RYVfgeI",
                                    "http://t.cn/RYVfsLo",
                                    "http://t.cn/RYMuvvn",
                                    "http://t.cn/RYVfnEO",
                                    "http://t.cn/RYVf1fd"])
        }
        
        cycleView.pageControlItemSize = CGSize(width: 16, height: 4)
        cycleView.pageControlItemRadius = 0
        cycleView.pageControlAlignment = .right
        tableView.tableHeaderView = cycleView
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "tableViewCellId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableVIewCellId")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellId") as! TableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableVIewCellId")
            return cell!
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 3 ? width*150/750 : 50
    }
}
