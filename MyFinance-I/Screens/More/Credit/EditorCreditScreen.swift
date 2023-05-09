import SwiftUI

struct EditorCreditScreen: View {
    
    enum FocusedField: Hashable {
        case borrower, amount, purpose
    }

    var creditManager: ViewModelCredit
    var credit: Credit?
    
    @State private var borrower             : String
    @State private var amount               : String
    @State private var purpose              : String
    @State private var date                 : Date
    @FocusState private var focusedField    : FocusedField?
    @Environment(\.dismiss) var dismiss
    
    init(creditManager: ViewModelCredit, credit: Credit? = nil) {
        self.creditManager = creditManager
        self.credit = credit
        
        if let credit {
            self._borrower  = State(initialValue: credit.borrower)
            self._amount    = State(initialValue: String(credit.amount))
            self._purpose   = State(initialValue: credit.purpose)
            self._date      = State(initialValue: credit.date)
        } else {
            self._borrower  = State(initialValue: "")
            self._amount    = State(initialValue: "")
            self._purpose   = State(initialValue: "")
            self._date      = State(initialValue: Date())
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("borrower", text: $borrower)
                    .focused($focusedField, equals: .borrower)
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
                    if let credit {
                        creditManager.update(credit, borrower: borrower, amount: Int(amount) ?? 0, purpose: purpose, date: date)
                    } else {
                        let credit = Credit()
                        credit.borrower = borrower
                        credit.amount = Int(amount) ?? 0
                        credit.purpose = purpose
                        credit.date = date
                        creditManager.save(credit)
                    }
                    dismiss()
                }
            }.onAppear {
                focusedField = .borrower
            }.padding()
        }
    }
}




































struct CreditEditorScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditorCreditScreen(creditManager: ViewModelCredit())
    }
}
