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
    static let georgianIcon = UIImage(named: "Georgian")
    static let asianIcon = UIImage(named: "Asian")
    static let europeanIcon = UIImage(named: "European")
}

extension Image {
    static let logoImage = Image(uiImage: UIImage.logoImage ?? UIImage())
    static let glassImage = Image(uiImage: UIImage.glassImage ?? UIImage())
}
