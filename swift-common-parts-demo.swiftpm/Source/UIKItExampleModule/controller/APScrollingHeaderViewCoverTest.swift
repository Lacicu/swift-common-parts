//
//  File.swift
//
//
//  Created by Kyosuke Kawamura on 2022/02/04.
//

import UIKit
import AccelParts

class APScrollingHeaderViewCoverTest: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let layout = APScrollingHeaderViewLayout()
        layout.header.height = 300
        layout.miniHeader.height = 100
        layout.mode = .cover
        
        let testView = TestCoverView(frame: view.frame, layout: layout)
        // testView.frame.origin = CGPoint(x: 20, y: 20) // add padding to check clipsToBounds
        testView.delegate = testView
        testView.datasource = testView
        view.addSubview(testView)
    }
}

class TestCoverView: APScrollingHeaderView {}
extension TestCoverView: APScrollingHeaderViewDatasource {
    
    func header(_ apScrollingHeaderView: APScrollingHeaderView) -> UIView {
        let header = UIView()
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 200, width: 140, height: 60)
        label.text = "test foreground"
        header.addSubview(label)
        header.backgroundColor = .yellow // test fot not being used
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: 0),
            label.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0)
        ])
        
        return header
    }
    
    func headerBackgroundImage(_ apScrollingHeaderView: APScrollingHeaderView) -> UIImage {
        return UIImage(named: "pokemon")!
    }
    
    func miniHeader(_ apScrollingHeaderView: APScrollingHeaderView) -> UIView {
        let header = UIView()
        header.backgroundColor = .blue
        return header
    }
    
    func scrollView(_ apScrollingHeaderView: APScrollingHeaderView) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: frame.width, height: frame.height * 3)
        
        let view = UIView(frame: CGRect(origin: .zero, size: scrollView.contentSize) )
        view.backgroundColor  = .green
        scrollView.addSubview(view)
        
        let top = UILabel()
        top.frame = CGRect(x: 0, y: 0, width: 0, height: 60)
        top.text = "Top of the ScrollView"
        top.sizeToFit()
        view.addSubview(top)
        
        let bottom = UILabel()
        bottom.frame = CGRect(x: 0, y: frame.height * 3 - 60, width: 0, height: 60)
        bottom.text = "Bottom of the ScrollView"
        bottom.sizeToFit()
        view.addSubview(bottom)
        
        return scrollView
    }
}

extension TestCoverView: APScrollingHeaderViewDelegate {
    func refresh(_ apScrollingHeaderView: APScrollingHeaderView, frame: CGRect) {
        print("refresh(_:frame:)")
    }
    
    func didScrollToBottom(_ apScrollingHeaderView: APScrollingHeaderView){
        print("didScrollToBottom(_:)")
    }
    
    func cover(_ apScrollingHeaderView: APScrollingHeaderView, headerRatio ratio: CGFloat) {
        print("cover(_: headerRatio: \(ratio)")
    }
}
