//
//  SecondaryButtonComponent.swift
//  Reserved
//
//  Created by Ani's Mac on 05.02.24.
//

import UIKit

class SecondaryButtonComponent: UIButton {
    // MARK: - Init
    init(text: String) {
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setTitleColor(UIColor.white, for: .normal)
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

