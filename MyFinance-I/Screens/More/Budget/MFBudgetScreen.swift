//
//  MFBudgetScreen.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import SwiftUI

struct MFBudgetScreen: View {
    
    @EnvironmentObject var vm: MFExpenseViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


















































































#Preview {
    MFBudgetScreen()
        .environmentObject(MFExpenseViewModel())
}
