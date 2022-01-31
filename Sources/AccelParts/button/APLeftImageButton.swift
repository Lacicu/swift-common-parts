//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//

import UIKit

public class APLeftImageButton: UIButton {
    public override func setImage(_ image: UIImage?, for state: State) {
        super.setImage(image, for: state)
        // transform to flip order
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
}
