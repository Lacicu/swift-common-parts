//
//  File.swift
//
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//
#if !os(macOS)
import UIKit

public class APSegmentController: UIView {
    internal var _currentIndex: Int?
    internal var currentIndex: Int {
        get {
            _currentIndex ?? 0
        }
        set(newIndex) {
            _currentIndex = max(min(newIndex, sections - 1), 0)
        }
    }
    
    internal var buttons: [APSegmentButton] = []
    internal var sections: Int {
        get {
            delegate?.numberOfSections?(self) ?? 0
        }
    }
    public var layout: APSegmentControllerLayout = APSegmentControllerLayout() {
        didSet {
            reloadData()
        }
    }
    
    public weak var delegate: APSegmentControllerDelegate? {
        didSet {
            reloadData()
        }
    }
    
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
        refresh()
    }
    
    internal func setDefaultView(){
        headerScroll?.layer.zPosition = 10
        headerScroll?.showsHorizontalScrollIndicator = false
        headerScroll?.showsVerticalScrollIndicator = false
        addSubview(headerScroll!)
        
        underline?.layer.zPosition = 20
    }
    
    internal func setLayout(){
        headerScroll?.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: layout.header.height))
        headerScroll?.backgroundColor = layout.header.backgroundColor
        
        underline?.frame.size = CGSize(width: layout.button.width, height: layout.underline.height)
        underline?.layer.cornerRadius = layout.underline.height / 2
        underline?.backgroundColor = layout.underline.backgroundColor
    }
    
    
    private func setHeader() {
        for v in headerScroll!.subviews {
            v.removeFromSuperview()
        }
    
        headerScroll?.addSubview(underline!)
        
        buttons = []
        let buttonSize = CGSize(width: layout.button.width, height: layout.header.height - layout.underline.height)
        var buttonX: CGFloat = layout.margin
        
        for i in 0..<sections {
            let button = APSegmentButton(index: i)
            button.setTitle(delegate?.title?(self, titleOfSection: i) ?? "", for: .normal)
            button.setTitleColor(layout.header.tintColor, for: .normal)
            button.addTarget(self, action: #selector(tapSegmentedButton(_:)), for: .touchUpInside)
            switch (layout.contentMode){
            case .constant:
                button.frame = CGRect(origin: CGPoint(x: CGFloat(i) * layout.button.width, y: 0), size: buttonSize)
            case .fit:
                button.sizeToFit()
                button.frame.size.height = buttonSize.height
                button.frame.origin = CGPoint(x: buttonX, y: 0)
                buttonX += button.frame.size.width + layout.margin
            }
            headerScroll!.addSubview(button)
            buttons.append(button)
        }
        
        underline?.frame.origin = CGPoint(x: buttons[currentIndex].frame.origin.x, y: layout.header.height - layout.underline.height)
        underline?.frame.size.width = buttons[currentIndex].frame.width
        
        headerScroll?.delegate = self
        switch (layout.contentMode){
        case .constant:
            headerScroll?.contentSize = CGSize(
                width: CGFloat(sections) * layout.button.width,
                height: layout.header.height
            )
        case .fit:
            headerScroll?.contentSize = CGSize(
                width: buttonX,
                height: layout.header.height
            )
        }
    }
    
    @objc private func tapSegmentedButton(_ sender: APSegmentButton) {
        currentIndex = sender.index
        swipeHeader()
    }
    
    internal func swipeHeader() {
        delegate?.hadInteraction?(self)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [self] in
            setSelectedButton()
        }, completion: { _ in
            self.didSelectedButton()
        })
    }
    
    internal func refresh() {
        setHeader()
    }
    
    private func setSelectedButton() {
        let leftEnd: CGFloat = buttons[currentIndex].frame.origin.x
        let rightEnd: CGFloat = buttons[currentIndex].frame.origin.x + buttons[currentIndex].frame.width
        
        if (leftEnd < headerScroll!.bounds.origin.x) {
            headerScroll!.bounds.origin.x = leftEnd
        } else if (headerScroll!.bounds.origin.x + headerScroll!.frame.width < rightEnd) {
            headerScroll!.bounds.origin.x = rightEnd - headerScroll!.frame.width
        }
        
        underline?.frame.origin.x = buttons[currentIndex].frame.origin.x
        underline?.frame.size.width = buttons[currentIndex].frame.width
    }
    
    internal func didSelectedButton() {
        delegate?.apSegmentController?(self, didSelectSection: currentIndex)
    }
}

extension APSegmentController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.hadInteraction?(self)
    }
}
#endif
