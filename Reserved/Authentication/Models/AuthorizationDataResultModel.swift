//
//  AuthorizationDataResultModel.swift
//  Reserved
//
//  Created by Ani's Mac on 16.01.24.
//

import Foundation
import FirebaseAuth

struct AuthorizationDataResultModel {
    let id: String
    let email: String?
    
    init(user: User) {
        self.id = user.uid
        self.email = user.email
    }
}
 
