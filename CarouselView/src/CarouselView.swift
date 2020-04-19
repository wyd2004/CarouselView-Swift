//
//  CarouselView.swift
//  CarouselView
//
//  Created by 王一丁 on 2020/4/18.
//  Copyright © 2020 yidingw. All rights reserved.
// https://www.pupboss.com/uitableview-internal-implementation/

import UIKit

protocol CarouselViewDelegate:AnyObject, UIScrollViewDelegate {
    func carouselView(_ carouselView: CarouselView?, willDisplay view: CarouselViewCell?, forRowAt index: Int)
    func carouselView(_ carouselView: CarouselView?, didEndDisplay view: CarouselViewCell?, forRowAt index: Int)
    func carouselView(_ carouselView: CarouselView?, didSelectRowAt index: Int)
    func carouselView(_ carouselView: CarouselView?, didDeSelectRowAt index: Int)
    func carouselView(_ carouselView: CarouselView?, currentIndex index: Int)
}

extension CarouselViewDelegate {
    func carouselView(_ carouselView: CarouselView?, willDisplay view: CarouselViewCell?, forRowAt index: Int) {}
    func carouselView(_ carouselView: CarouselView?, didEndDisplay view: CarouselViewCell?, forRowAt index: Int) {}
    func carouselView(_ carouselView: CarouselView?, didSelectRowAt index: Int) {}
    func carouselView(_ carouselView: CarouselView?, didDeSelectRowAt index: Int) {}
    func carouselView(_ carouselView: CarouselView?, currentIndex index: Int) {}
}

protocol CarouselViewDataSource: AnyObject {
    func numberOfRow(in carouselView: CarouselView?) -> Int
    func carouselView(_ carouselView: CarouselView?, viewForRowAt index: Int) -> CarouselViewCell?
}

class CarouselView: UIView {
    //MARK: - delegate
    public weak var dataSource: CarouselViewDataSource? {
        didSet {
            reloadData()
        }
    }
    public weak var delegate: CarouselViewDelegate?
    //MARK: - set
    var rowWidth: CGFloat = 320 {
        didSet {
            var frame = self.scrollView.frame
            var center = self.scrollView.center
            center.x = self.center.x
            self.scrollView.center = center
            frame.size.width = self.rowWidth
            self.scrollView.frame = frame
            reloadData()
        }
    }
    override var clipsToBounds: Bool {
        set {
            self.scrollView.clipsToBounds = newValue
        }
        get {
            return self.scrollView.clipsToBounds
        }
    }
    var isPagingEnabled: Bool {
        set {
            self.scrollView.isPagingEnabled = newValue
        }
        get {
            return self.scrollView.isPagingEnabled
        }
    }
    
    //MARK: - Pirvate Property
    private let scrollView: UIScrollView = UIScrollView.init()
    private var numberOfRows: Int = 0
    private var reusableViewPool: Set<CarouselViewCell> = Set()
    private var registerClass: AnyClass?
    private var currentIndex: Int = 0
    private var cardInset: CGFloat = 0.0
    
    let BayCarouselViewIdentifier:String = "CarouselViewIdentifier";
    let CarouselDefaultScaleX: CGFloat = 0.9;
    let CarouselDefaultScaleY: CGFloat = 0.8;
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
        self.scrollView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        for view in self.scrollView.subviews {
            view.isHidden = true
        }
        self.reusableViewPool.removeAll()
        self.numberOfRows = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        
        var frame = self.scrollView.frame
        frame.size.width = self.rowWidth
        self.scrollView.frame = frame
        self.scrollView.contentSize = CGSize(width: self.rowWidth * CGFloat(self.numberOfRows), height: self.frame.size.height)
        self.scrollView.contentOffset = CGPoint(x: self.rowWidth * CGFloat(self.currentIndex), y: 0)
        
        var center = self.scrollView.center
        center.x = self.center.x
        self.scrollView.center = center
        
        for view in self.scrollView.subviews {
            let view = view as! CarouselViewCell
            var center = view.center;
            center.x = (CGFloat(view.itemIndex) + 0.5) * self.rowWidth;
            center.y = self.center.y;
            view.center = center;
        }
        
        self.scrollViewDidScroll(self.scrollView)
    }
}

//MARK: - ScrollViewDelegate

extension CarouselView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let padding = (self.frame.size.width - self.rowWidth)/2
        
        let maxX = scrollView.contentOffset.x + self.scrollView.frame.size.width
        let minX = scrollView.contentOffset.x
        
        for view in scrollView.subviews {
            if view is CarouselViewCell {
                let view = view as! CarouselViewCell
                if view.frame.maxX < minX - padding * 2 || view.frame.minX > maxX + padding * 2 {
                    if !view.isHidden {
                        queueReusableView(view)
                        view.isHidden = true
                        guard let _ = self.delegate?.carouselView(self, didEndDisplay: view, forRowAt: view.itemIndex) else {
                            return
                        }
                    }
                }
                
                let viewCenterX = view.center.x
                let centerX = scrollView.contentOffset.x + self.rowWidth / 2
                var scale = (centerX - viewCenterX) / self.rowWidth
                if scale < 0 {
                    scale = scale * -1
                }
                let scaleX = 1 - CGFloat(1 - self.CarouselDefaultScaleX) * scale
                let scaleY = 1 - CGFloat(1 - self.CarouselDefaultScaleY) * scale
                
                view.transform = CGAffineTransform.init(scaleX: scaleX, y: scaleY)
                var center = view.center
                center.x = (CGFloat(view.itemIndex) + 0.5) * self.rowWidth
                center.y = self.center.y
                view.center = center
                view.setNeedsLayout()
            }
        }
        
        let subViewsArray = self.scrollView.subviews.sorted { $0.frame.origin.x < $1.frame.origin.x }
        
        var firstView: CarouselViewCell?
        for i in 0..<subViewsArray.count {
            if subViewsArray[i] is CarouselViewCell {
                if !subViewsArray[i].isHidden {
                    firstView = subViewsArray[i] as? CarouselViewCell
                    break
                }
            }
        }
        
        var lastView: CarouselViewCell?
        for i in stride(from: subViewsArray.count - 1, through: 0, by: -1) {
            if subViewsArray[i] is CarouselViewCell {
                if !subViewsArray[i].isHidden {
                    lastView = subViewsArray[i] as? CarouselViewCell
                    break
                }
            }
        }
        //如果符合条件就生成右边的view
        if let lastView = lastView, lastView.frame.maxX < maxX + padding - self.cardInset {
            self.currentIndex = lastView.itemIndex
            if lastView.itemIndex + 1 < self.numberOfRows {
                generateViewWithIndex(lastView.itemIndex + 1)
            }
        }
        
        //如果符合条件就生成左边的view
        if let firstView = firstView, firstView.frame.minX > minX - padding + self.cardInset {
            self.currentIndex = firstView.itemIndex
            if firstView.itemIndex > 0 {
                generateViewWithIndex(firstView.itemIndex - 1)
            }
        }
        //如果一个 subview 都没有,执行类似 reloadData
        if firstView == nil && lastView == nil {
            self.currentIndex = Int(scrollView.contentOffset.x / self.rowWidth)
            renderCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let _ = self.delegate?.carouselView(self, currentIndex: self.currentIndex) else { return }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // setContentOffset 之后，并且跟上次不一样的才会调用
        scrollViewDidScroll(self.scrollView)
    }
}

//MARK: Private
extension CarouselView {
    
    func renderCurrentView() -> Void {
        generateViewWithIndex(self.currentIndex)
    }
    
    private func queueReusableView(_ view: CarouselViewCell) {
        self.reusableViewPool.insert(view)
    }
    
    private func generateViewWithIndex(_ index: Int) {
        if self.numberOfRows <= index {
            return
        }
        if let view = self.dataSource?.carouselView(self, viewForRowAt: index) {
            view.itemIndex = index
            self.cardInset = (self.rowWidth - view.frame.width)/2
            
            if (index != self.currentIndex) {
                view.transform = CGAffineTransform.init(scaleX: CarouselDefaultScaleX, y: CarouselDefaultScaleY)
            }
            var center = view.center
            center.x = (CGFloat(view.itemIndex) + 0.5) * self.rowWidth
            center.y = self.center.y
            view.center = center
            
            guard let _ = self.delegate?.carouselView(self, willDisplay: view, forRowAt: view.itemIndex) else {
                return
            }
            view.isHidden = false
        }
    }
}

//MARK: Public
extension CarouselView {
    
    public func resetData() -> Void {
        for view in self.scrollView.subviews {
            view.isHidden = true
        }
    }
    
    public func dequeueReusableView() -> CarouselViewCell? {
        if let view = self.reusableViewPool.randomElement() {
            view.transform = CGAffineTransform.identity
            self.reusableViewPool.remove(view)
            return view
        } else {
            if let registerView = self.registerClass as? CarouselViewCell.Type {
                let view = registerView.init()
                self.scrollView.addSubview(view)
                return view
            }
        }
        return nil
    }
    
    public func registerClass(viewClass: AnyClass?) {
        self.registerClass = viewClass
    }
    
    public func reloadData() {
        commonInit()
        
        guard let _ = self.dataSource else { return }
        
        if let numberOfRows = self.dataSource?.numberOfRow(in: self) {
            self.numberOfRows = numberOfRows
        } else {
            return
        }
        
        self.scrollView.contentSize = CGSize.init(width: self.rowWidth * CGFloat(self.numberOfRows), height: self.frame.size.height)
        
        if self.scrollView.subviews.count == 0 {
            // 整个的思路是在屏幕上先加上一个肯定存在的 view，再在 scrollViewDidScroll 里面决定哪些需要删去，哪些需要生成
            renderCurrentView()
        }
    }
    
    public func scrollToIndex(index: Int, animate:Bool) {
        self.currentIndex = index
        let index = CGFloat(index)
        renderCurrentView()
        if self.rowWidth * index == self.scrollView.contentOffset.x {
            self.scrollView.setContentOffset(CGPoint.init(x: self.rowWidth * index + 1, y: 0), animated: animate)
        } else {
            self.scrollView.setContentOffset(CGPoint.init(x: self.rowWidth * index, y: 0), animated: animate)
        }
    }
    
}

