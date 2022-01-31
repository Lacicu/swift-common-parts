//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//
#if !os(macOS)
import UIKit

internal class APSegmentButton: UIButton {
    private var _index: Int?
    internal var index: Int {
        get {
            guard let i = _index else {
                return -1
            }
            return i
        }
        set(newIndex) {
            _index = newIndex
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    init(index: Int) {
        super.init(frame: CGRect())
        _index = index
    }
}
#endif
