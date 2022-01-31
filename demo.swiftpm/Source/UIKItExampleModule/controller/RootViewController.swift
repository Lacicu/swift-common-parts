//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//

import UIKit
import AccelParts

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let b =  APLeftImageButton()
        b.setTitle("テストボタン", for: .normal)
        b.frame = CGRect(x: 50, y: 100, width: 200, height: 60)
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.backgroundColor = .gray
        view.addSubview(b)
    }
}
