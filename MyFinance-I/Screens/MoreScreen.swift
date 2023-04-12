//
//  MoreView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 12/04/23.
//

import SwiftUI

struct MoreScreen: View {
    var features = ["Expenses By Category"]
    
    var body: some View {
        NavigationStack {
            List(features.indices, id: \.self) { index in
                NavigationLink(destination: ExpensesByCategoryScreen(), label: {
                    Text("\(features[index])")
                })
            }
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreScreen()
    }
}
