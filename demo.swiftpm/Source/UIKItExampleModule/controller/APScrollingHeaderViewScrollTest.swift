//
//  File.swift
//  
//
//  Created by Kyosuke Kawamura on 2022/02/04.
//

import UIKit
import AccelParts

class APScrollingHeaderViewScrollTest: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let layout = APScrollingHeaderViewLayout()
        layout.header.height = 300
        layout.miniHeader.height = 100
        layout.mode = .scroll
        
        let testView = TestScrollView(frame: view.frame, layout: layout)
        testView.delegate = testView
        testView.datasource = testView
        view.addSubview(testView)
    }
}

class TestScrollView: APScrollingHeaderView {}
extension TestScrollView: ScrollHeaderViewDatasource {
    
    func header(_ apScrollingHeaderView: APScrollingHeaderView) -> UIView {
        let header = UIView()
        let label = UILabel()
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 60)
        label.text = "test foreground"
        header.addSubview(label)
        header.backgroundColor = .yellow // test fot not being used
        return header
    }
    
    func miniHeader(_ apScrollingHeaderView: APScrollingHeaderView) -> UIView {
        let header = UIView()
        header.backgroundColor = .blue
        return header
    }
    
    func scrollView(_ apScrollingHeaderView: APScrollingHeaderView) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor  = .green
        scrollView.contentSize = CGSize(width: frame.width, height: frame.height * 3)
        return scrollView
    }
}

extension TestScrollView: APScrollingHeaderViewDelegate {
    func refresh(_ apScrollingHeaderView: APScrollingHeaderView, frame: CGRect) {
        print("refresh(_:frame:)")
    }
    
    func didScrollToBottom(_ apScrollingHeaderView: APScrollingHeaderView){
        print("didScrollToBottom(_:)")
    }
}
