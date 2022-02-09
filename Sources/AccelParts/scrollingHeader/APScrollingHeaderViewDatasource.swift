//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/02/04.
//
#if !os(macOS)
import UIKit

@objc public protocol ScrollHeaderViewDatasource: NSObjectProtocol {
    @objc optional func scrollView(_ apScrollingHeaderView: APScrollingHeaderView) -> UIScrollView
    @objc optional func header(_ apScrollingHeaderView: APScrollingHeaderView) -> UIView
    @objc optional func headerBackground(_ apScrollingHeaderView: APScrollingHeaderView) -> UIView
    @objc optional func miniHeader(_ apScrollingHeaderView: APScrollingHeaderView) -> UIView
}
#endif
