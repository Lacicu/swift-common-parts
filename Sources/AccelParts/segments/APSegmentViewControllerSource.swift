//
//  File.swift
//
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//
#if !os(macOS)
import UIKit

@objc public protocol APSegmentViewControllerSource: NSObjectProtocol {
    @objc optional func body(_ sender: APSegmentViewController, frame: CGRect, bodyOfSection section: Int) -> UIView
}
#endif

