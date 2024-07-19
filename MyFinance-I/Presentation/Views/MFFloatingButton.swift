//
//  MFFloatingButton.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import SwiftUI

struct MFFloatingButton: View {
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 64)
                .foregroundColor(.addButtonColor)
                .padding()
                .onTapGesture {
                    onTap()
                }
            Image(systemName: "plus")
                .foregroundColor(.white)
        }
    }
}









































































#Preview {
    MFFloatingButton { }
}
