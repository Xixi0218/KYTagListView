//
//  KYTagListView.swift
//  KYTagsView
//
//  Created by Ye Keyon on 2022/12/10.
//

import UIKit

class KYTagListView: UIView {
    
    /// 在显示的标签
    private var displayViews = [KYTagListViewReusable]()
    /// 准备复用的标签
    private var reuseViews = [KYTagListViewReusable]()
    /** 标签行间距 default is 10*/
    var minimumLineSpacing: CGFloat = 10.0
    /** 标签的间距 default is 10*/
    var minimumInteritemSpacing: CGFloat = 10.0
    /** tagsSupView的边距 default is top:0,letf:0,bottom:0,right:0*/
    var contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    /** tagsView 宽度 default  is 屏幕宽度  */
    var tagsViewWidth = UIScreen.main.bounds.width
    private var identifiers = [String: AnyClass]()
    
    private var contentSize = CGSize.zero
    weak var dataSource: KYTagListViewDataSource?
    
    func reloadData() -> Void {
        
        var tagX: CGFloat = contentInset.left
        var tagY: CGFloat = contentInset.top
        var tagW: CGFloat = 0.0
        var tagH: CGFloat = 0.0
        
        var lastView: KYTagListViewReusable?
        
        prepareForReuse()
        
        for subView in displayViews {
            
            tagW = subView.calculateWidth()
            tagH = subView.calculateHeight()
            
            if let lastView = lastView {
                if lastView.frame.maxX + contentInset.right + minimumInteritemSpacing + tagW > tagsViewWidth {
                    tagX = contentInset.left
                    tagY = lastView.frame.maxY + minimumLineSpacing
                }else {
                    tagX = lastView.frame.maxX + minimumInteritemSpacing
                }
            }
            
            subView.frame = CGRect(x: tagX, y: tagY, width: tagW, height: tagH)
            lastView = subView
        }
        
        let sumHeight: CGFloat = lastView?.frame.maxY ?? 0
        let viewContentSize = CGSize(width: tagsViewWidth, height: sumHeight)
        
        frame.size.height = sumHeight
        
        if (!contentSize.equalTo(viewContentSize)) {
            contentSize = viewContentSize;
            // 通知外部IntrinsicContentSize失效
            invalidateIntrinsicContentSize()
        }
        
    }
    
    /// 准备复用
    func prepareForReuse() {
        guard let dataSource = dataSource else { return }
        let labelsCount = dataSource.numberOfItems(in: self)
        let displayCount = displayViews.count
        
        /// labels数量比views数量少，移除差异，并加入复用池
        if labelsCount < displayCount {
            let diff = displayCount - labelsCount
            var rangeViews = displayViews[0..<diff]
            for _ in 0..<diff {
                let view = rangeViews.removeLast()
                appendReuseView(view)
            }
        }
        
        for index in 0..<labelsCount {
            let label = dataSource.tagListView(self, forItemAt: index)
            addView(label)
        }
        debugPrint("待复用的数量reuseCount: \(reuseViews.count)")
    }
    
    public override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

extension KYTagListView {
    func registerLabelClass<T>(ofType type: T.Type) where T: KYTagListViewReusable {
        self.identifiers[T.reuseIdentifier] = type.self
    }
}

extension KYTagListView {
    /// 根据index查找一个标签视图，没有则创建
    func dequeueReusableLabel<T>(ofType type: T.Type, index: Int) -> T where T: KYTagListViewReusable {
        return dequeueReusableLabel(withIdentifier: T.reuseIdentifier, index: index) as! T
    }
    
    private func dequeueReusableLabel(withIdentifier identifier: String, index: Int) -> KYTagListViewReusable {
        if index < displayViews.count {
            let label = displayViews[index]
            return label
        }
        
        // 复用池不够时创建新的
        if reuseViews.count > 0 {
            let view = reuseViews.removeLast()
            return view
        }
        guard let clas = self.identifiers[identifier] else {
            fatalError("identifier is not register")
        }
        guard let viewClass = clas as? KYTagListViewReusable.Type else {
            fatalError("class do not comply KYTagListViewReusable")
        }
        return viewClass.init()
    }
    
    private func addView(_ view: KYTagListViewReusable) {
        addSubview(view)
        let index = displayViews.lastIndex { tagView in
            return tagView == view
        }
        if index == nil {
            displayViews.append(view)
        }
    }
    
    /// 往复用池中添加
    private func appendReuseView(_ view: KYTagListViewReusable) {
        view.removeFromSuperview()
        let index = displayViews.lastIndex { tagView in
            return tagView == view
        }
        if let index = index {
            displayViews.remove(at: index)
        }
        reuseViews.append(view)
    }
}
