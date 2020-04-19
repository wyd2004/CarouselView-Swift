//
//  CarouselViewCell.swift
//  CarouselView
//
//  Created by 王一丁 on 2020/4/18.
//  Copyright © 2020 yidingw. All rights reserved.
//

import UIKit

class CarouselViewCell: UIView {
    var itemIndex = Int.min
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
