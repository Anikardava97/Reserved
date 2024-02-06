//
//  CircularButton.swift
//  Reserved
//
//  Created by Ani's Mac on 06.02.24.
//

import UIKit

final class CircularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.clipsToBounds = true
    }
}
