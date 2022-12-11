//
//  KYTagModelProtocol.swift
//  KYTagsView
//
//  Created by Ye Keyon on 2022/12/11.
//

import UIKit

protocol KYTagListViewReusable: UIView {
    func calculateWidth() -> CGFloat
    func calculateHeight() -> CGFloat
    static var reuseIdentifier: String { get }
}

protocol KYTagListViewDataSource: AnyObject {
    func tagListView(_ tagListView: KYTagListView, forItemAt index: Int) -> KYTagListViewReusable
    func numberOfItems(in tagListView: KYTagListView) -> Int
}
