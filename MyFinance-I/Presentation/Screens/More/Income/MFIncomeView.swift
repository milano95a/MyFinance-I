//
//  MFIncomeView.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 12/07/24.
//

import SwiftUI

struct MFIncomeView: View {
    @ObservedObject var viewModel: MFIncomeViewModel
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    MFIncomeView(viewModel: MFIncomeViewModel())
}
