//
//  KYTagView.swift
//  KYTagsView
//
//  Created by Ye Keyon on 2022/12/11.
//

import UIKit

class KYCuotomTagView: UIView, KYTagListViewReusable {
    
    var contentRect: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func readData(title: String) {
        titleLabel.text = title
        contentRect = title.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin], attributes: [.font: UIFont.systemFont(ofSize: 12)], context: nil)
        titleLabel.frame = contentRect
    }
    
    private func configSubView() {
        addSubview(titleLabel)
    }
    
    static var reuseIdentifier: String {
        return "KYTagView"
    }
    
    func calculateWidth() -> CGFloat {
        return ceil(contentRect.width)
    }
    
    func calculateHeight() -> CGFloat {
        return ceil(contentRect.height)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()

}
