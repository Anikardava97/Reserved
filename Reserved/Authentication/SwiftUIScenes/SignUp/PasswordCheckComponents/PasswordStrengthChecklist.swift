//
//  PasswordStrengthChecklist.swift
//  Reserved
//
//  Created by Ani's Mac on 17.01.24.
//

import SwiftUI

struct PasswordStrengthChecklist: View {
    //MARK: - Properties
    var isPasswordMinimumLengthMet: Bool
    var isPasswordUniqueCharacterMet: Bool
    
    //MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ChecklistItem(title: "At least 8 characters", isMet: isPasswordMinimumLengthMet)
            ChecklistItem(title: "Contains a special character", isMet: isPasswordUniqueCharacterMet)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}
