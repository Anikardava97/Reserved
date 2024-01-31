//
//  MainButtonComponent.swift
//  Reserved
//
//  Created by Ani's Mac on 20.01.24.
//

import UIKit

class MainButtonComponent: UIButton {
    // MARK: - Init
    init(text: String, textColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
