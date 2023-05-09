import SwiftUI

struct EditorDebtScreen: View {
    
    enum FocusedField: Hashable {
        case creditor, amount, purpose
    }

    var debtManager: ViewModelDebt
    var debt: Debt?
    
    @State private var creditor             : String
    @State private var amount               : String
    @State private var purpose              : String
    @State private var date                 : Date
    @FocusState private var focusedField    : FocusedField?
    @Environment(\.dismiss) var dismiss
    
    init(debtManager: ViewModelDebt, debt: Debt? = nil) {
        self.debtManager = debtManager
        self.debt = debt
        
        if let debt {
            self._creditor  = State(initialValue: debt.creditor)
            self._amount    = State(initialValue: String(debt.amount))
            self._purpose   = State(initialValue: debt.purpose)
            self._date      = State(initialValue: debt.date)
        } else {
            self._creditor  = State(initialValue: "")
            self._amount    = State(initialValue: "")
            self._purpose   = State(initialValue: "")
            self._date      = State(initialValue: Date())
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("creditor", text: $creditor)
                    .focused($focusedField, equals: .creditor)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .amount }
                TextField("amount", text: $amount)
                    .keyboardType(.numbersAndPunctuation)
                    .focused($focusedField, equals: .amount)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .purpose }
                TextField("purpose", text: $purpose)
                    .focused($focusedField, equals: .purpose)
                    .submitLabel(.done)
                DatePicker("date", selection: $date, displayedComponents: [.date])
                
                Spacer()
                
                Button("Save") {
                    if let debt {
                        debtManager.update(debt, creditor: creditor, amount: Int(amount) ?? 0, purpose: purpose, date: date)
                    } else {
                        let debt = Debt()
                        debt.creditor = creditor
                        debt.amount = Int(amount) ?? 0
                        debt.purpose = purpose
                        debt.date = date
                        debtManager.save(debt)
                    }
                    dismiss()
                }
            }.onAppear {
                focusedField = .creditor
            }.padding()
        }
    }
}






























































struct DebtEditorScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditorDebtScreen(debtManager: ViewModelDebt())
    }
}
