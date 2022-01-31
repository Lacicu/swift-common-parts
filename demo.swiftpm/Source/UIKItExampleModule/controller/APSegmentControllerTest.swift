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
    var segmentView: APSegmentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // set layout
        let l1 = APSegmentControllerLayout()
        l1.header.height = 40
        l1.underline.height = 4
        l1.underline.backgroundColor = .orange
        
        // set controller
        segment = APSegmentController(frame: view.frame, layout: l1)
        segment?.frame.origin = CGPoint(x: 0, y: 120)
        segment?.delegate = self
        view.addSubview(segment!)
        
        
        // set layout
        let l2 = APSegmentControllerLayout()
        l2.header.height = 40
        l2.underline.height = 4
        l2.underline.backgroundColor = .green
        l2.body.height = 160
        l2.swipeable = true
        
        // set controller
        segmentView = APSegmentViewController(frame: view.frame, layout: l2)
        segmentView?.frame.origin = CGPoint(x: 0, y: 200)
        segmentView?.delegate = self
        segmentView?.viewsource = self
        view.addSubview(segmentView!)
    }
}

extension APSegmentControllerTest: APSegmentControllerDelegate {
    func numberOfSections() -> Int {
        titles.count
    }
    
    func title(titleOfSection section: Int) -> String {
        titles[section]
    }
    
    func apSegmentController(_ sender: APSegmentController, didSelectSection section: Int){
        print("apSegmentController(_:didSelectSection) section:\(section)")
    }
    
    func hadInteraction(_ controller: APSegmentController){
        print("hadInteraction(_:)")
    }
}

extension APSegmentControllerTest: APSegmentViewControllerSource {
    func body(frame: CGRect, bodyOfSection section: Int) -> UIView {
        let v = UIView(frame: frame)
        v.backgroundColor = [UIColor.red, UIColor.blue, UIColor.black, UIColor.yellow][section % 4]
        return v
    }
}

