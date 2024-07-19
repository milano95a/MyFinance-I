//
//  MFToolbar.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import SwiftUI

struct MFToolbar: ToolbarContent {
    var onSettingTap: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button(action: {
                onSettingTap()
            }, label: {
                Image(systemName: "gear")
            })
        }
    }
}













































































#Preview {
    NavigationStack {
        VStack {
            
        }
        .navigationTitle("Budget")
        .toolbar { MFToolbar { }}
    }
}
