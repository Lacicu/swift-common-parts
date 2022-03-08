//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/02/04.
//
#if !os(macOS)
import UIKit

open class APScrollingHeaderView: UIView {
    
    private var header: UIView?
    private var headerBackground: UIView?
    private var headerBackgroundImage: UIImage?
    private var miniHeader: UIView?
    private var scrollView: UIScrollView?
    
    public var layout: APScrollingHeaderViewLayout {
        didSet {
            setLayout()
            refresh(frame: frame)
        }
    }
    
    open weak var delegate: APScrollingHeaderViewDelegate? {
        didSet {
            refresh(frame: frame)
        }
    }
    
    open weak var datasource: APScrollingHeaderViewDatasource? {
        didSet {
            scrollView = datasource?.scrollView?(self) ?? UIScrollView()
            scrollView?.layer.zPosition = 10
            scrollView?.clipsToBounds = true
            
            header = datasource?.header?(self) ?? UIView()
            header?.clipsToBounds = true
            header?.layer.zPosition = 20
            
            // priority [headerBackground > headerBackgroundImage]
            if let hbg = datasource?.headerBackground?(self) {
                headerBackground = hbg
            } else {
                headerBackground = UIView()
                headerBackgroundImage = datasource?.headerBackgroundImage?(self)
            }
            headerBackground?.clipsToBounds = true
            headerBackground?.layer.zPosition = -10
            
            miniHeader = datasource?.miniHeader?(self) ?? UIView()
            miniHeader?.alpha = 0
            miniHeader?.clipsToBounds = true
            miniHeader?.layer.zPosition = 30
            
            setLayout()
            refresh(frame: frame)
        }
    }
    
    private func setLayout(){
        scrollView?.frame.origin = CGPoint(x: 0, y: layout.header.height)
        scrollView?.frame.size = CGSize(width: frame.width, height: frame.height - layout.header.height)
        if (layout.mode == .cover){ // if cover mode
            scrollView?.bounces = true
            scrollView?.alwaysBounceVertical = true
            scrollView?.showsVerticalScrollIndicator = false
        }
        
        header?.frame.size = CGSize(width: frame.width, height: layout.header.height)
        if (layout.mode == .cover){ // if cover mode(header backgorund will be clear to show bg view)
            header?.backgroundColor = .clear
        }
        
        headerBackground?.frame.size = CGSize(width: frame.width, height: layout.header.height + layout.backgroundOffset)
        
        miniHeader?.frame.size = CGSize(width: frame.width, height: layout.miniHeader.height)
    }
    
    private func refresh(frame: CGRect) {
        for v in subviews {
            v.removeFromSuperview()
        }
        if let h = header {
            addSubview(h)
        }
        if let hbg = headerBackground {
            addSubview(hbg)
            
            // add image if image is set
            if let image = headerBackgroundImage {
                let imageView = UIImageView()
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                hbg.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: hbg.topAnchor, constant: 0),
                    imageView.bottomAnchor.constraint(equalTo: hbg.bottomAnchor, constant: 0),
                    imageView.centerXAnchor.constraint(equalTo: hbg.centerXAnchor, constant: 0)
                ])
            }
        }
        if let mh = miniHeader {
            addSubview(mh)
        }
        
        scrollView?.delegate = self
        if let sv = scrollView {
            addSubview(sv)
        }
        delegate?.refresh?(self, frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        self.layout = APScrollingHeaderViewLayout()
        super.init(coder: coder)
        setUp()
    }
    
    override init(frame: CGRect) {
        self.layout = APScrollingHeaderViewLayout()
        super.init(frame: frame)
        setUp()
    }
    
    public init(frame: CGRect, layout: APScrollingHeaderViewLayout){
        self.layout = layout
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp(){
        backgroundColor = .white
    }
}

extension APScrollingHeaderView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bounds = scrollView.bounds
        let deltaY: CGFloat = bounds.origin.y
        if (deltaY <= 0) { // 上を表示
            if (header!.frame.origin.y == 0){ // bouncing
                header?.frame.size.height = layout.header.height - deltaY
                headerBackground?.frame.size.height = max(
                    layout.header.height - deltaY,
                    layout.header.height + layout.backgroundOffset)
                return
            }
            if (scrollView.frame.origin.y < layout.header.height) { // ヘッダー移動中
                // スクロールの移動を計算
                scrollView.frame.origin.y -= deltaY
                scrollView.bounds.origin.y = 0
                header?.frame.origin.y = scrollView.frame.origin.y - layout.header.height
                headerBackground?.frame.size.height = max(scrollView.frame.origin.y + layout.backgroundOffset, (layout.header.height + layout.backgroundOffset) * layout.backgroundRatio)
                
                // viewの高さを計算
                scrollView.frame.size.height = frame.height - scrollView.frame.origin.y
                
                // viewの透過度を調整
                let ratio = (scrollView.frame.origin.y - safeAreaInsets.top) / (layout.header.height - safeAreaInsets.top)
                header?.alpha = layout.header.alpha(ratio: ratio)
                headerBackground?.alpha = layout.header.alpha(ratio: ratio)
                miniHeader?.alpha = layout.miniHeader.alpha(ratio: 1 - ratio)
                delegate?.cover?(self, headerRatio: ratio)
            } else {
                // スクロールの移動を計算
                scrollView.frame.origin.y = layout.header.height
                header?.frame.origin.y = 0
                headerBackground?.frame.size.height = scrollView.frame.origin.y + layout.backgroundOffset
                
                // viewの高さを計算
                scrollView.frame.size.height = frame.height - scrollView.frame.origin.y
                
                // viewの透過度を調整
                header?.alpha = layout.header.alpha(ratio: 1)
                headerBackground?.alpha = layout.header.alpha(ratio: 1)
                miniHeader?.alpha = layout.miniHeader.alpha(ratio: 0)
                delegate?.cover?(self, headerRatio: 1)
            }
        } else { // 下を表示
            if (scrollView.frame.origin.y > safeAreaInsets.top) { // ヘッダー移動中
                
                // スクロールの移動を計算
                scrollView.frame.origin.y -= deltaY
                scrollView.bounds.origin.y = 0
                header?.frame.origin.y = scrollView.frame.origin.y - layout.header.height
                headerBackground?.frame.size.height = max(scrollView.frame.origin.y + layout.backgroundOffset, (layout.header.height + layout.backgroundOffset) * layout.backgroundRatio)
                
                // viewの高さを計算
                scrollView.frame.size.height = frame.height - scrollView.frame.origin.y
                
                // viewの透過度を調整
                let ratio = (scrollView.frame.origin.y - safeAreaInsets.top) / (layout.header.height - safeAreaInsets.top)
                header?.alpha = layout.header.alpha(ratio: ratio)
                headerBackground?.alpha = layout.header.alpha(ratio: ratio)
                miniHeader?.alpha = layout.miniHeader.alpha(ratio: 1 - ratio)
                delegate?.cover?(self, headerRatio: ratio)
            } else {
                // スクロールの移動を計算
                scrollView.frame.origin.y = safeAreaInsets.top
                
                // viewの高さを計算
                scrollView.frame.size.height = frame.height - scrollView.frame.origin.y
                
                // viewの透過度を調整
                header?.alpha = layout.header.alpha(ratio: 0)
                headerBackground?.alpha = layout.header.alpha(ratio: 0)
                miniHeader?.alpha = layout.miniHeader.alpha(ratio: 1)
                delegate?.cover?(self, headerRatio: 0)
            }
        }
        
        // 一番下でさらにドラッグされたら追加読込
        if bounds.origin.y >= (scrollView.contentSize.height - scrollView.frame.height + (layout.miniHeader.height - safeAreaInsets.top)) {
            
            delegate?.didScrollToBottom?(self)
        }
    }
}
#endif
