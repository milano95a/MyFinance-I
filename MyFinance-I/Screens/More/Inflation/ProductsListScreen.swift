//
//  ProductsListScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 03/05/23.
//

import SwiftUI

struct ProductsListScreen: View {
    @EnvironmentObject var expenseManager: ManagerExpense
    
    var body: some View {
        List(expenseManager.getUniqueProducts()) { product in
            NavigationLink("\(product.name)", destination: {
                InflationScreen(items: expenseManager.getProductInflation(product))
            })
        }
    }
}

struct ProductsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListScreen()
            .environmentObject(ManagerExpense.shared)
    }
}
