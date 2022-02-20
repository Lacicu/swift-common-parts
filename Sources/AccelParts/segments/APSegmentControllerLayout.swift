//
//  File.swift
//
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//
#if !os(macOS)
import UIKit

public class APSegmentControllerLayout {
    
    public init(){}
    
    public var swipeable = false
    public var header: Header = Header(height: 40, tintColor: .black, backgroundColor: .clear)
    public class Header: View {
        public var tintColor: UIColor
        public var font: UIFont = UIFont.systemFont(ofSize: 12)
        public init(height: CGFloat, tintColor: UIColor, backgroundColor: UIColor){
            self.tintColor = tintColor
            super.init(height: height, backgroundColor: backgroundColor)
        }
    }
    
    public var underline: View = View(height: 3, backgroundColor: .systemBlue)
    public var body: View = View(height: 0, backgroundColor: .clear)
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
    
    public var contentMode: Mode = .constant
    public var margin: CGFloat = 20
    public enum Mode {
        case constant
        case fit
    }
}
#endif
