//
//  UIButton + Extension.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/12.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

extension UIButton {

    convenience init(title: String, imgName: String, fontSize: CGFloat = 12, fontColor: UIColor = UIColor.darkGrayColor()) {
    
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        setImage(UIImage(named: imgName), forState: UIControlState.Normal)
        setTitleColor(fontColor, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}
