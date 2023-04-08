//
//  HomeTabView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 07/04/23.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            ExpenseScreen(vm: ExpenseViewModel.shared)
                .tabItem {
                    Label("Expenses", systemImage: "dollarsign.circle")
                }
            Text("More")
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
