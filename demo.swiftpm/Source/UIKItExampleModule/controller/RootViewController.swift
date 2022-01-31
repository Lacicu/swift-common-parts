//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//

import UIKit
import AccelParts

class RootViewController: UIViewController {
    
    let controllers: [UIViewController] = [APSegmentControllerTest()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        controllers.forEach({ c in
            c.view.frame = view.frame
            if (c is APSegmentControllerTest){
                (c as! APSegmentControllerTest).segment?.reloadData()
            }
            let button = UIButton()
            button.setTitle(String(describing: c), for: .normal)
            button.backgroundColor = .systemBlue
            button.frame.origin = CGPoint(x: 0, y: 40)
            button.frame.size = CGSize(width: view.frame.width, height: 60)
            button.tag = controllers.firstIndex(of: c)!
            button.addTarget(self, action: #selector(self.tap(_:)), for: .touchUpInside)
            view.addSubview(button)
        })
        
//        let b =  APLeftImageButton()
//        b.setTitle("テストボタン", for: .normal)
//        b.frame = CGRect(x: 50, y: 100, width: 200, height: 60)
//        b.setImage(UIImage(systemName: "xmark"), for: .normal)
//        b.backgroundColor = .gray
//        view.addSubview(b)
        
    }
    
    @objc func tap(_ sender: UIButton) {
        if let nav = navigationController {
            nav.pushViewController(controllers[sender.tag], animated: true)
        }
    }
}
