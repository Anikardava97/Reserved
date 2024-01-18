//
//  ChecklistItem.swift
//  Reserved
//
//  Created by Ani's Mac on 17.01.24.
//

import SwiftUI

struct ChecklistItem: View {
    //MARK: - Properties
    var title: String
    var isMet: Bool
    
    //MARK: - Body
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isMet ? "checkmark" : "checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(isMet ? .green : Color.white.opacity(0.7))
            
            Text(title)
                .foregroundColor(isMet ? .green : Color.white.opacity(0.7))
                .font(.system(size: 14))
        }
    }
}
