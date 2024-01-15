//
//  Image+Extension.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import UIKit
import SwiftUI

extension UIImage {
    static let logoImage = UIImage(named: "Logo")
    static let glassImage = UIImage(named: "Glass")
}

extension Image {
    static let logoImage = Image(uiImage: UIImage.logoImage ?? UIImage())
    static let glassImage = Image(uiImage: UIImage.glassImage ?? UIImage())
}
