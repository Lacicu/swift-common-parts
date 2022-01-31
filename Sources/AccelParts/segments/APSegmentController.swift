//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//

import UIKit

public class APSegmentControllerLayout {
    
    public init(){}
    
    public var header: Header = Header(height: 40, tintColor: .black, backgroundColor: .clear)
    public class Header: View {
        public var tintColor: UIColor
        public init(height: CGFloat,tintColor: UIColor, backgroundColor: UIColor){
            self.tintColor = tintColor
            super.init(height: height, backgroundColor: backgroundColor)
        }
    }
    
    public var underline: View = View(height: 3, backgroundColor: .systemBlue)
    public var body: View = View(height: 200, backgroundColor: .clear)
    public class View {
        public var height: CGFloat
        public var backgroundColor: UIColor
        public init(height: CGFloat, backgroundColor: UIColor){
            self.height = height
            self.backgroundColor = backgroundColor
        }
    }
    
    public var button: Button = Button()
    public class Button {
        public init(){}
        public var width: CGFloat = 80
    }
    
    public var swipeable = false
}

@objc public protocol APSegmentControllerDelegate: NSObjectProtocol {
    @objc optional func numberOfSections() -> Int
    @objc optional func title(titleOfSection section: Int) -> String
    @objc optional func body(frame: CGRect, bodyOfSection section: Int) -> UIView
    
    /**
     * called when the menu changes or header scrolls
     */
    @objc optional func hadInteraction(_ controller: APSegmentController)
}

public class APSegmentController: UIView {
    private var _currentIndex: Int?
    private var currentIndex: Int {
        get {
            _currentIndex ?? 0
        }
        set(newIndex) {
            _currentIndex = max(min(newIndex, sections - 1), 0)
        }
    }
    
    private var buttons: [APSegmentButton] = []
    private var sections: Int {
        get {
            delegate?.numberOfSections?() ?? 0
        }
    }
    public var layout: APSegmentControllerLayout = APSegmentControllerLayout() {
        didSet {
            setLayout()
            refresh(frame: frame)
        }
    }
    
    public weak var delegate: APSegmentControllerDelegate? {
        didSet {
            refresh(frame: frame)
        }
    }
    
    private var bodyView: UIView? = UIView()
    private var underline: UIView? = UIView()
    private var headerScroll: UIScrollView?  = UIScrollView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDefaultView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaultView()
    }
    
    public init(frame: CGRect, layout: APSegmentControllerLayout = APSegmentControllerLayout()) {
        super.init(frame: frame)
        self.layout = layout
        setDefaultView()
    }
    
    public func reloadData(){
        setLayout()
        refresh(frame: frame)
    }
    
    private func setDefaultView(){
        headerScroll?.layer.zPosition = 10
        headerScroll?.showsHorizontalScrollIndicator = false
        headerScroll?.showsVerticalScrollIndicator = false
        addSubview(headerScroll!)
        
        underline?.layer.zPosition = 20
        
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
    
    private func setLayout(){
        headerScroll?.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: layout.header.height))
        headerScroll?.backgroundColor = layout.header.backgroundColor
        
        underline?.frame.size = CGSize(width: layout.button.width, height: layout.underline.height)
        underline?.layer.cornerRadius = layout.underline.height / 2
        underline?.backgroundColor = layout.underline.backgroundColor
        
        bodyView?.frame = CGRect(x: 0, y: layout.header.height, width: frame.width, height: layout.body.height)
    }
    
    
    private func setHeader() {
        for v in headerScroll!.subviews {
            v.removeFromSuperview()
        }
        
        underline?.frame.origin = CGPoint(x: 0, y: layout.header.height - layout.underline.height)
        headerScroll?.addSubview(underline!)
        
        buttons = []
        let buttonSize = CGSize(width: layout.button.width, height: layout.header.height - layout.underline.height)
        
        for i in 0..<sections {
            let button = APSegmentButton(index: i)
            button.setTitle(delegate?.title?(titleOfSection: i) ?? "", for: .normal)
            button.setTitleColor(layout.header.tintColor, for: .normal)
            button.addTarget(self, action: #selector(tapSegmentedButton(_:)), for: .touchUpInside)
            button.frame = CGRect(origin: CGPoint(x: CGFloat(i) * layout.button.width, y: 0), size: buttonSize)
            headerScroll!.addSubview(button)
            buttons.append(button)
        }
        
        headerScroll?.delegate = self
        headerScroll?.contentSize = CGSize(
            width: CGFloat(sections) * layout.button.width,
            height: layout.header.height
        )
    }
    
    @objc private func tapSegmentedButton(_ sender: APSegmentButton) {
        currentIndex = sender.index
        swipeHeader()
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
    
    private func swipeHeader() {
        delegate?.hadInteraction?(self)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [self] in
            let leftEnd: CGFloat = CGFloat(currentIndex) * layout.button.width
            let rightEnd: CGFloat = CGFloat(currentIndex + 1) * layout.button.width
            
            if (leftEnd < headerScroll!.bounds.origin.x) {
                headerScroll!.bounds.origin.x = leftEnd
            } else if (headerScroll!.bounds.origin.x + headerScroll!.frame.width < rightEnd) {
                headerScroll!.bounds.origin.x = rightEnd - headerScroll!.frame.width
            }
            
            underline?.frame.origin.x = CGFloat(currentIndex) * layout.button.width
        }, completion: { _ in
            self.refreshBody()
        })
    }
    
    private func refresh(frame: CGRect) {
        setHeader()
        refreshBody()
    }
    
    private func refreshBody() {
        buttons.forEach { button in
            button.isSelected = button.index == currentIndex
        }
        for v in bodyView!.subviews {
            v.removeFromSuperview()
        }
        guard let v = delegate?.body?(frame: bodyView!.frame, bodyOfSection: currentIndex) else {
            return
        }
        v.clipsToBounds = true
        v.frame.origin.y = 0
        v.frame.size.height = layout.body.height
        bodyView?.addSubview(v)
    }
}

extension APSegmentController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.hadInteraction?(self)
    }
}
