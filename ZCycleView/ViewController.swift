//
//  ViewController.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/18.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    
    @IBOutlet weak var cycleView1: ZCycleView!
    @IBOutlet weak var cycleView2: ZCycleView!
    @IBOutlet weak var cycleView3: ZCycleView!
    @IBOutlet weak var cycleView4: ZCycleView!
    @IBOutlet weak var cycleView5: ZCycleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // example 01
        cycleView1.placeholderImage = #imageLiteral(resourceName: "placeholder")
        cycleView1.setUrlsGroup(["http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg", "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg", "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png"])
        cycleView1.pageControlIndictirColor = UIColor.green
        cycleView1.pageControlCurrentIndictirColor = UIColor.red
        cycleView1.scrollDirection = .vertical
        cycleView1.didSelectedItem = {
            print("cycleView1 didSelectedItem:  \($0)")
        }
        
        // example 02
        cycleView2.timeInterval = 3
        cycleView2.placeholderImage = #imageLiteral(resourceName: "placeholder")//
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.cycleView2.setUrlsGroup(["http://t.cn/RYMuvvn","http://t.cn/RYVfnEO","http://t.cn/RYVf1fd","http://t.cn/RYVfgeI","http://t.cn/RYVfsLo"])
        }
        cycleView2.pageControlItemSize = CGSize(width: 16, height: 4)
        cycleView2.pageControlCurrentItemSize = CGSize(width: 10, height: 10)
        cycleView2.pageControlIndictirColor = UIColor.red
        cycleView2.pageControlCurrentIndictirColor = UIColor.blue
        cycleView2.pageControlHeight = (cycleView2.frame.size.height-90*1.3)/2
        cycleView2.itemSize = CGSize(width: 240, height: 90)
        cycleView2.itemZoomScale = 1.2
        cycleView2.didSelectedItem = {
            print("cycleView2 didSelectedItem:  \($0)")
        }
        
        
        // example 03
        cycleView3.setTitlesGroup(["更多title/item/pageControl使用方式，请参考API","GitHub: https://github.com/MQZHot/ZCycleView","如有问题，欢迎issue，联系QQ：735481274","或者联系邮箱 ---- mqz1228@163.com", "欢迎star✨✨✨✨✨✨，谢谢支持"])
        cycleView3.setTitleImagesGroup([#imageLiteral(resourceName: "activity"),#imageLiteral(resourceName: "activity"),#imageLiteral(resourceName: "activity")], sizeGroup: [CGSize(width: 30, height: 15),CGSize(width: 30, height: 15),CGSize(width: 30, height: 15)])
        cycleView3.titleBackgroundColor = UIColor.white
        cycleView3.titleColor = UIColor.blue
        cycleView3.scrollDirection = .vertical
        cycleView3.didSelectedItem = {
            print("cycleView3 didSelectedItem:  \($0)")
        }
        
        // example 04
        cycleView4.setImagesGroup([#imageLiteral(resourceName: "pic1"),#imageLiteral(resourceName: "pic2"),#imageLiteral(resourceName: "pic3"),#imageLiteral(resourceName: "pic4")], titlesGroup: ["天天特价 -- 超值量贩，底价疯抢天天特价","一缕情丝，一缕温暖","快速匹配，及时推送","气质春装，一件包邮"])
        cycleView4.itemSize = CGSize(width: width-160, height: (width-160)*300/750)
        cycleView4.itemSpacing = 40
        cycleView4.itemZoomScale = 1.2
        cycleView4.itemBorderWidth = 1
        cycleView4.itemBorderColor = UIColor.gray
        cycleView4.pageControlIndictorImage = #imageLiteral(resourceName: "github")
        cycleView4.pageControlCurrentIndictorImage = #imageLiteral(resourceName: "evernote")
        cycleView4.pageControlHeight = 18
        cycleView4.pageControlItemSize = CGSize(width: 16, height: 16)
        cycleView4.pageControlAlignment = .right
        cycleView4.didSelectedItem = {
            print("cycleView4 didSelectedItem:  \($0)")
        }
        
        
        // example 05
        let titles: [NSString] = ["正在直播·2017维密直播大秀\n天使惊艳合体性感开撩","猎场-会员抢先看\n胡歌陈龙联手戳穿袁总阴谋","我的！体育老师\n好样的！前妻献媚讨好 张嘉译一口回绝","小宝带你模拟断案！\n开局平民，晋升全靠运筹帷幄","【挑战极限·精华版】孙红雷咆哮洗车被冻傻"]
        
        let attibutedTitles = titles.map { (str) -> NSAttributedString in
            let arr = str.components(separatedBy: "\n")
            let attriStr = NSMutableAttributedString(string:str as String)
            attriStr.addAttributes([.foregroundColor: UIColor.green, .font: UIFont.systemFont(ofSize: 13)], range: NSMakeRange(0, arr[0].count))
            if arr.count > 1 {
                attriStr.addAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 11)], range: NSMakeRange(arr[0].count+1, arr[1].count))
            }
            return attriStr
        }
        
        cycleView5.timeInterval = 3
        cycleView5.setImagesGroup([#imageLiteral(resourceName: "p700-300-1"),#imageLiteral(resourceName: "p700-300-2"),#imageLiteral(resourceName: "p700-300-3"),#imageLiteral(resourceName: "p700-300-4"),#imageLiteral(resourceName: "p700-300-5")], attributedTitlesGroup: attibutedTitles)
        cycleView5.itemSize = CGSize(width: width-40, height: (width-40)*30/70)
        cycleView5.itemSpacing = 5
        cycleView5.titleBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        cycleView5.titleNumberOfLines = 0
        cycleView5.titleViewHeight = 40
        cycleView5.pageControlIsHidden = true
    }
    deinit {
        print("dealloc")
    }
}
