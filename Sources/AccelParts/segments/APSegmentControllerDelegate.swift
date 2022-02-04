//
//  File.swift
//
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//
#if !os(macOS)
import UIKit

@objc public protocol APSegmentControllerDelegate: NSObjectProtocol {
    @objc optional func numberOfSections(_ sender: APSegmentController) -> Int
    @objc optional func title(_ sender: APSegmentController, titleOfSection section: Int) -> String
    
    @objc optional func apSegmentController(_ sender: APSegmentController, didSelectSection section: Int)
    
    /**
     * called when the menu changes or header scrolls
     */
    @objc optional func hadInteraction(_ controller: APSegmentController)
}
#endif
