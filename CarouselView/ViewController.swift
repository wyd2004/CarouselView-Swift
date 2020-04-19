//
//  ViewController.swift
//  CarouselView
//
//  Created by 王一丁 on 2020/4/18.
//  Copyright © 2020 yidingw. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CarouselViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let carouselView = CarouselView.init(frame: self.view.bounds)
        carouselView.registerClass(viewClass: CarouselViewCellTester.self)
        carouselView.rowWidth = 300
        carouselView.backgroundColor = .white
        carouselView.dataSource = self
        carouselView.clipsToBounds = false
        carouselView.isPagingEnabled = true
        self.view.addSubview(carouselView)
    }
    
    func numberOfRow(in carouselView: CarouselView?) -> Int {
        return 20
    }
    
    func carouselView(_ carouselView: CarouselView?, viewForRowAt index: Int) -> CarouselViewCell? {
        
        if let cell = carouselView?.dequeueReusableView(), cell is CarouselViewCellTester {
            let cell = cell as! CarouselViewCellTester
            var frame = cell.frame
            frame.size = CGSize.init(width: 280, height: 527)
            cell.frame = frame
            cell.text = "当前 index: \(index)"
            cell.backgroundColor = .cyan
            return cell
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
