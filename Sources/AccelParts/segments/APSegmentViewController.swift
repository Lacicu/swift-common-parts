//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//
#if !os(macOS)
import UIKit

@objc public protocol APSegmentViewControllerSource: NSObjectProtocol {
    @objc optional func body(frame: CGRect, bodyOfSection section: Int) -> UIView
}

public class APSegmentViewController: APSegmentController {
    public weak var viewsource: APSegmentViewControllerSource? {
        didSet {
            reloadData()
        }
    }
    
    private var bodyView: UIView? = UIView()
    
    override internal func setDefaultView(){
        super.setDefaultView()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(sender:)))
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.direction = .right
        bodyView?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(sender:)))
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.direction = .left
        bodyView?.addGestureRecognizer(swipeLeft)
        addSubview(bodyView!)
    }
    
    override internal func setLayout(){
        super.setLayout()
        bodyView?.frame = CGRect(x: 0, y: layout.header.height, width: frame.width, height: layout.body.height)
    }
    
    @objc private func swipeLeft(sender: AnyObject) {
        if (!layout.swipeable){
            return
        }
        currentIndex = currentIndex + 1
        swipeHeader()
    }
    
    @objc private func swipeRight(sender: AnyObject) {
        if (!layout.swipeable){
            return
        }
        currentIndex = currentIndex - 1
        swipeHeader()
    }
    
    
    override internal func refresh() {
        super.refresh()
        refreshBody()
    }
    
    override internal func didSelectedButton() {
        super.didSelectedButton()
        refreshBody()
    }
    
    internal func refreshBody() {
        for v in bodyView!.subviews {
            v.removeFromSuperview()
        }
        guard let v = viewsource?.body?(frame: bodyView!.frame, bodyOfSection: currentIndex) else {
            return
        }
        v.clipsToBounds = true
        v.frame.origin.y = 0
        v.frame.size.height = layout.body.height
        bodyView?.addSubview(v)
    }
}
#endif
