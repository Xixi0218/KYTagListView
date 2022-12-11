//
//  ViewController.swift
//  KYTagListView
//
//  Created by Ye Keyon on 2022/12/10.
//

import UIKit

class ViewController: UIViewController {
    
    let dataSource = ["今天", "明天", "我们的爱", "周杰伦", "无与伦比", "世界有你才好", "大岩姐姐", "Today at Swift", "杨孝远"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sharpTagsView)
        NSLayoutConstraint.activate([
            sharpTagsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            sharpTagsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            sharpTagsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
        
        sharpTagsView.reloadData()
    }
    
    private lazy var sharpTagsView: KYTagListView = {
        let view = KYTagListView()
        view.registerLabelClass(ofType: KYCuotomTagView.self)
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}

extension ViewController: KYTagListViewDataSource {
    func tagListView(_ tagListView: KYTagListView, forItemAt index: Int) -> KYTagListViewReusable {
        let view = tagListView.dequeueReusableLabel(ofType: KYCuotomTagView.self, index: index)
        view.readData(title: dataSource[index])
        return view
    }
    
    func numberOfItems(in tagListView: KYTagListView) -> Int {
        return dataSource.count
    }
    
}
