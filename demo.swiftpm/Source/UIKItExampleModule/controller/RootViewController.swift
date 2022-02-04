//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//

import UIKit
import AccelParts

class RootViewController: UIViewController {
    
    let controllers: [UIViewController] = [
        APSegmentControllerTest(),
        APScrollingHeaderViewTest()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        var counter = 0
        
        controllers.forEach({ c in
            c.view.frame = view.frame
            switch(String(describing: type(of: c))){
            case "APSegmentControllerTest":
                (c as! APSegmentControllerTest).segment?.reloadData()
                (c as! APSegmentControllerTest).segmentView?.reloadData()
            case "APScrollingHeaderViewTest":
                print("No Action for now")
            default:
                print("No Action")
            }
            
            let button = UIButton()
            button.setTitle(String(describing: type(of: c)), for: .normal)
            button.backgroundColor = .systemBlue
            button.frame.origin = CGPoint(x: 0, y: 40 + counter * 80)
            button.frame.size = CGSize(width: view.frame.width, height: 60)
            button.tag = controllers.firstIndex(of: c)!
            button.addTarget(self, action: #selector(self.tap(_:)), for: .touchUpInside)
            view.addSubview(button)
            counter += 1
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
