//
//  CreditCard.swift
//  Reserved
//
//  Created by Ani's Mac on 09.02.24.
//

import Foundation

struct CreditCard: Codable {
    let name: String
    let number: String
    let expirationDate: String
    let cvc: String
}
