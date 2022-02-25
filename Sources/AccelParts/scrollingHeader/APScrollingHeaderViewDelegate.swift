//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/02/04.
//
#if !os(macOS)
import UIKit

@objc public protocol APScrollingHeaderViewDelegate: NSObjectProtocol {
    @objc optional func refresh(_ apScrollingHeaderView: APScrollingHeaderView, frame: CGRect)
    @objc optional func cover(_ apScrollingHeaderView: APScrollingHeaderView, headerRatio ratio: CGFloat)
    @objc optional func didScrollToBottom(_ apScrollingHeaderView: APScrollingHeaderView)
}
#endif
