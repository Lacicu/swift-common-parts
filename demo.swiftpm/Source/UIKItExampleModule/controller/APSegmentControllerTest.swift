//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/01/31.
//

import UIKit
import AccelParts

class APSegmentControllerTest: UIViewController {
    
    let titles = ["国語", "英語", "数学", "理科", "社会", "道徳", "体育", "保健"]
    var segment: APSegmentController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // set layout
        let l = APSegmentControllerLayout()
        l.header.height = 40
        l.underline.height = 4
        l.underline.backgroundColor = .green
        l.body.height = view.frame.height - l.header.height - 80
        l.swipeable = true
        
        // set controller
        segment = APSegmentController(frame: view.frame, layout: l)
        segment?.frame.origin = CGPoint(x: 0, y: 80)
        segment?.delegate = self
        view.addSubview(segment!)
    }
}

extension APSegmentControllerTest: APSegmentControllerDelegate {
    func numberOfSections() -> Int {
        titles.count
    }
    
    func title(titleOfSection section: Int) -> String {
        titles[section]
    }
    
    func body(frame: CGRect, bodyOfSection section: Int) -> UIView {
        let v = UIView(frame: frame)
        v.backgroundColor = [UIColor.red, UIColor.blue, UIColor.black, UIColor.yellow][section % 4]
        return v
    }
    
    func hadInteraction(_ controller: APSegmentController) {
        print("hadInteraction(_:)")
    }
}
