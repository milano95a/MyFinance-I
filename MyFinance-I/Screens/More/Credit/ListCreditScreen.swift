import SwiftUI

struct ListCreditScreen: View {
    
    @ObservedObject var creditManager: CreditManager
    @State private var showAddCreditPopup = false
    @State private var selectedCredit: Credit?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                listOfCredits
                addButton
            }
        }
    }
}

extension ListCreditScreen {
    @ViewBuilder
    var listOfCredits: some View {
        List(creditManager.credits.freeze()) { credit in
            CreditListItemView(credit: credit)
                .swipeActions {
                    Button("Paid") {
                        creditManager.paid(credit)
                    }.tint(.green)
                    Button("Delete") {
                        creditManager.delete(credit)
                    }.tint(.red)
                    Button("Edit") {
                        selectedCredit = credit
                        showAddCreditPopup = true
                    }.tint(.blue)
                }
        }
        .popover(isPresented: $showAddCreditPopup) { [selectedCredit] in
            EditorCreditScreen(creditManager: creditManager, credit: selectedCredit)
        }
    }
    
    var addButton: some View {
        ZStack {
            Circle()
                .frame(width: 48)
                .foregroundColor(.addButtonColor)
                .padding()
                .onTapGesture {
                    showAddCreditPopup = true
                }
            Image(systemName: "plus")
                .foregroundColor(.white)
        }
    }
}






















































struct CreditScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListCreditScreen(creditManager: CreditManager())
    }
}
