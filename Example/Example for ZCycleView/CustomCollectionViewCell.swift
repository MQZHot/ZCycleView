//
//  CustomCollectionViewCell.swift
//  Example for ZCycleView
//
//  Created by bigPro on 2021/3/12.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    lazy var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = contentView.bounds
        contentView.addSubview(imageView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
