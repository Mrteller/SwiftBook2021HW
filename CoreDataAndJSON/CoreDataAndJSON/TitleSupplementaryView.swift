//
//  TitleSupplementaryView.swift
//  CoreDataAndJSON
//
//  Created by  Paul on 26.01.2022.
//
import UIKit

class TitleSupplementaryView: UITableViewHeaderFooterView {
    let label = UILabel()
    //static let reuseIdentifier = "title-supplementary-reuse-identifier"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSupplementaryView {
    func configure() {
        
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        // We should add not to the view itself but to content view. And do it before setting constraints.
        contentView.addSubview(label)
//        let inset = CGFloat(10)
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
//            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
//            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
//            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
//        ])
    }
}
