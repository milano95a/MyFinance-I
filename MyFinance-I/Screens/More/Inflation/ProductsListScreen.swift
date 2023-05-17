//
//  ProductsListScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 03/05/23.
//

import SwiftUI

struct ProductsListScreen: View {
    @EnvironmentObject var manager: InflationManager
    
    var body: some View {
        List(manager.getUniqueProducts()) { product in
            NavigationLink("\(product.name)", destination: {
                InflationScreen(items: manager.giveMeInflationFor(product: product.name))
            })
        }
    }
}

struct ProductsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListScreen()
            .environmentObject(ManagerExpense())
    }
}
