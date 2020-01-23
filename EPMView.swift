//
//  EPMView.swift
//  ZapposEmoji
//
//  Created by npegnatz on 1/21/20.
//  Copyright © 2020 Nicholas Egnatz. All rights reserved.
//

import Foundation
import UIKit

class EPMView: UIView {
    
    let epmLabel: UILabel = {
        let label = UILabel()
        label.text = "EPM"
        label.font = UIFont.customBoldFont(size: 16)
        label.textColor = UIColor.textColor()
        return label
    }()
    
    let epmValue: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.customFont(size: 16)
        label.textColor = UIColor.textColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    func create() {
        let stack = UIStackView(arrangedSubviews: [epmLabel, epmValue])
        stack.axis = .horizontal
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
