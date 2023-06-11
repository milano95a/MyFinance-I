//
//  HomeTabView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 07/04/23.
//

import SwiftUI

struct InitialTabScreen: View {
    
    var body: some View {
        TabView {
            ListExpenseScreen()
                .tabItem {
                    Label("Expenses", systemImage: "dollarsign.circle")
                }
            MoreScreen()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
        }
    }
}













































struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        InitialTabScreen()
    }
}
