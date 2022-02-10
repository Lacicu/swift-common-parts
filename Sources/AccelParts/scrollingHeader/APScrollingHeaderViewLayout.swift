//
//  File.swift
//
//
//  Created by Kyosuke Kawamura on 2022/02/04.
//
#if !os(macOS)
import UIKit

public class APScrollingHeaderViewLayout {
    /**
     * determine how the header scrolls
     */
    public enum Mode {
        case scroll
        case cover
    }
    
    public init(){}

    public var header: Header = Header(height: 300)
    public var miniHeader: Header = Header(height: 100)
    
    public var mode: Mode = .scroll
    public var backgroundOffset: CGFloat = 50
    
    internal var backgroundExpansion: CGFloat = 1.05
    internal var backgroundRatio: CGFloat = 0.8
    
    public class Header {
        public var height: CGFloat
        public var maxAlpha: CGFloat = 1
        public var minAlpha: CGFloat = 0
        
        public init(height: CGFloat) {
            self.height = height
        }
        
        internal func alpha(ratio: CGFloat) -> CGFloat {
            (maxAlpha - minAlpha) * ratio + minAlpha
        }
    }
}
#endif
