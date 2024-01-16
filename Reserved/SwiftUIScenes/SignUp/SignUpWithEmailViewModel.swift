//
//  SignUpWithEmailViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import Foundation


final class SignUpWithEmailViewModel: ObservableObject {
    // MARK: - Properties
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
}
