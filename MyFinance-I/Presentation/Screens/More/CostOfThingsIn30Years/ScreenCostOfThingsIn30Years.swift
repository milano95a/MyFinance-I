//
//  ScreenCostOfThingsIn30Years.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 19/05/23.
//

import SwiftUI

struct ScreenCostOfThingsIn30Years: View {
    @EnvironmentObject var manager: ManagerCostOfThingsIn30Years
    
    var body: some View {
        List(manager.items) { item in
            HStack {
                Text("\(item.name)")
                Spacer()
                Text("\(item.cost)")
            }
        }
    }
}

struct ScreenCostOfThingsIn30Years_Previews: PreviewProvider {
    static var previews: some View {
        ScreenCostOfThingsIn30Years()
    }
}
