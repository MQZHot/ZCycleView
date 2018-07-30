//
//  ZCycleViewCell.swift
//  ZCycleView
//
//  Created by mengqingzheng on 2017/11/17.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit
import Kingfisher

enum ResourceType {
    case image
    case imageURL
    case text
}

class ZCycleViewCell: UICollectionViewCell {
    
    var titleContainerViewH: CGFloat = 25
    /// set text
    func attributeString(_ attributeString: NSAttributedString?, titleImgURL: String? = nil, titleImage: UIImage? = nil, titleImageSize: CGSize? = nil) {
        
        titleLabel.attributedText = attributeString
        titleContainerView.frame = CGRect(x: 0, y: contentView.bounds.size.height-titleContainerViewH, width: contentView.bounds.size.width, height:titleContainerViewH)
        titleContainerView.isHidden = attributeString == nil || attributeString?.string == "" ? true : false
        let containerViewSize = titleContainerView.bounds.size
        if let imageSize = titleImageSize {
            titleImageView.frame = CGRect(x: 5, y: (containerViewSize.height-imageSize.height)/2, width: imageSize.width, height: imageSize.height)
            titleLabel.frame = CGRect(x: 6+imageSize.width, y: 0, width: containerViewSize.width-6-imageSize.width, height: containerViewSize.height)
        } else {
            titleImageView.frame = CGRect.zero
            titleLabel.frame = CGRect(x: 5, y: 0, width: containerViewSize.width-5, height: containerViewSize.height)
        }
        
        if titleImgURL != nil {
            if let url = URL(string: titleImgURL!) {
                titleImageView.kf.setImage(with: url)
            }
        } else {
            titleImageView.image = titleImage
        }
    }
    /// set image
    func imageUrl(_ imageUrl: String?, placeholder: UIImage?) {
        guard let imageUrl = imageUrl,
            let url = URL(string: imageUrl) else {
                imageView.image = placeholder
                return
        }
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.3))])
    }
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var titleContainerView: UIView!
    var titleImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageView()
        addTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImageView() {
        imageView = UIImageView(frame: contentView.bounds)
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    func addTitleLabel() {
        titleContainerView = UIView(frame: CGRect(x: 0, y: contentView.bounds.size.height-25, width: contentView.bounds.size.width, height: 25))
        titleContainerView.isHidden = true
        contentView.addSubview(titleContainerView)
        
        titleImageView = UIImageView()
        titleContainerView.addSubview(titleImageView)
        
        titleLabel = UILabel()
        titleLabel.clipsToBounds = true
        titleContainerView.addSubview(titleLabel)
    }
}
