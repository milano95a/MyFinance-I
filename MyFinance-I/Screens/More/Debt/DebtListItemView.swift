import SwiftUI

struct DebtListItemView: View {
    var debt: Debt
    
    var body: some View {
        VStack {
            HStack {
                if debt.isPaid {
                    Text("✅")
                }
                VStack(alignment: .leading) {
                    Text("\(debt.creditor)")
                    Text("\(debt.amount)")
                    Text("\(debt.purpose)")
                    Text("\(debt.date.friendlyDate)")
                }
            }
        }
    }
}






























































struct DebtListItemView_Previews: PreviewProvider {
    static var previews: some View {
        DebtListItemView(debt: Debt())
    }
}
