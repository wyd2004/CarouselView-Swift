//
//  CarouselViewCellTester.swift
//  CarouselView
//
//  Created by 王一丁 on 2020/4/19.
//  Copyright © 2020 yidingw. All rights reserved.
//

import UIKit

class CarouselViewCellTester: CarouselViewCell {

    var text: String {
        set {
            self.label.text = newValue
        }
        get {
            return self.label.text ?? ""
        }
    }
    
    private let label: UILabel = UILabel.init()
    
    required init() {
        super.init()
        self.label.font = UIFont.systemFont(ofSize: 20)
        self.label.textColor = .blue
        self.label.textAlignment = .center
        self.addSubview(self.label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
    }
    
}
