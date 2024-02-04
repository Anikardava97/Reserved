//
//  UserDefaults+Extension.swift
//  Reserved
//
//  Created by Ani's Mac on 04.02.24.
//

import Foundation

extension UserDefaults {
    func keyForUserSpecificData(base: String, userId: String) -> String {
        return "\(userId)_\(base)"
    }
}
