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
        testView.delegate = testView
        testView.datasource = testView
        view.addSubview(testView)
    }
}

class TestCoverView: APScrollingHeaderView {}
extension TestCoverView: ScrollHeaderViewDatasource {
    
    func header(_ apScrollingHeaderView: APScrollingHeaderView) -> UIView {
        let header = UIView()
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 200, width: 140, height: 60)
        label.text = "test foreground"
        header.addSubview(label)
        header.backgroundColor = .yellow // test fot not being used
        return header
    }
    
    func headerBackground(_ apScrollingHeaderView: APScrollingHeaderView) -> UIView {
        let header = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemon")
        imageView.contentMode = .scaleAspectFit
        header.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: header.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: 0),
            imageView.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0)
//            , imageView.widthAnchor.constraint(equalTo: header.centerYAnchor, constant: 0)
        ])
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

extension TestCoverView: APScrollingHeaderViewDelegate {
    func refresh(_ apScrollingHeaderView: APScrollingHeaderView, frame: CGRect) {
        print("refresh(_:frame:)")
    }
    
    func didScrollToBottom(_ apScrollingHeaderView: APScrollingHeaderView){
        print("didScrollToBottom(_:)")
    }
}
