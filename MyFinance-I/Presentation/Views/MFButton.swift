//
//  MFButton.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 05/06/24.
//

import SwiftUI

struct MFButton: View {
    var title: String
    var onTap: () -> Void
    
    init(_ title: String, onTap: @escaping () -> Void) {
        self.title = title
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.yellow1)
        .foregroundStyle(Color.white)
        .addBorder(.clear, cornerRadius: 16)
        
    }
}

#Preview {
    MFButton("Save") { }
}
