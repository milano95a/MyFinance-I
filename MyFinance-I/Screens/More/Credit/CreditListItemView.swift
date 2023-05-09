//
//  CreditListItemView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 19/04/23.
//

import SwiftUI

struct CreditListItemView: View {
    var credit: Credit
    
    var body: some View {
        VStack {
            HStack {
                if credit.isPaid {
                    Text("✅")
                }
                VStack(alignment: .leading) {
                    Text("\(credit.borrower)")
                    Text("\(credit.amount)")
                    Text("\(credit.purpose)")
                    Text("\(credit.date.friendlyDate)")
                }
            }
        }
    }
}
















































struct CreditListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CreditListItemView(credit: Credit())
    }
}
