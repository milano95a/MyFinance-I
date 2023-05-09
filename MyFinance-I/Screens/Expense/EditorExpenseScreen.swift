import SwiftUI
import RealmSwift

struct EditorExpenseScreen: View {
    
    enum FocusedField: Hashable {
        case name, category, price, quantity
    }
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: ManagerExpense
    var expense: Expense?
    
    @State private var name: String
    @State private var category: String
    @State private var price: String
    @State private var quantity: String
    @State private var date: Date
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            expenseForm
            Spacer()
            saveButton
        }.padding()
    }
}

extension EditorExpenseScreen {
    
    init(vm: ManagerExpense, expense: Expense? = nil) {
        self.vm = vm
        self.expense = expense
        if let expense {
            self._name = State(initialValue: expense.name)
            self._price = State(initialValue: String(expense.price))
            self._quantity = State(initialValue: String(expense.quantity))
            self._date = State(initialValue: expense.date)
            self._category = State(initialValue: expense.category)
        } else {
            self._name = State(initialValue: "")
            self._price = State(initialValue: "")
            self._quantity = State(initialValue: "")
            self._date = State(initialValue: Date())
            self._category = State(initialValue: "")
        }
    }

    var expenseForm: some View {
        VStack {
            nameTextFieldWithAutoCompleteSuggestion
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .category }
                .selectAllTextOnEditing()
            
            cateogryTextFieldWithAutoCompleteSuggestion
                .focused($focusedField, equals: .category)
                .submitLabel(.next)
                .onSubmit { focusedField = .price }
                .selectAllTextOnEditing()

            TextField("price", text: $price)
                .keyboardType(.numbersAndPunctuation)
                .focused($focusedField, equals: .price)
                .submitLabel(.next)
                .onSubmit { focusedField = .quantity }
                .selectAllTextOnEditing()

            TextField("quantity", text: $quantity)
                .keyboardType(.numbersAndPunctuation)
                .focused($focusedField, equals: .quantity)
                .submitLabel(.done)
                .selectAllTextOnEditing()

            DatePicker("date", selection: $date, displayedComponents: [.date])
        }.onAppear {
            focusedField = .name
        }
    }
    
    var nameTextFieldWithAutoCompleteSuggestion: some View {
        TextFieldWithAutoCompleteSuggestion<Expense>(
            getSuggestions: { typedText in
                vm.getSuggestions(with: typedText)
            },
            placeholderText: "name",
            textBinding: $name,
            onSuggestionTap: { expense in
                name = expense.name
                category = expense.category
                price = "\(expense.price)"
                quantity = "\(expense.quantity)"
            },
            getSuggestionText: { expense in
                expense.name
            })
    }
    
    var cateogryTextFieldWithAutoCompleteSuggestion: some View {
        TextFieldWithAutoCompleteSuggestion<String>(
            getSuggestions: { typedText in
                Array(vm.getCategorySuggestions(with: typedText))
            },
            placeholderText: "cateogry",
            textBinding: $category,
            onSuggestionTap: { category in
                self.category = category
            },
            getSuggestionText: { category in
                category
            })
    }
    
    var saveButton: some View {
        GeometryReader { geometry in
            Button(action: {
                print("hello")
                // TODO: validate
                if name.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ||
                    category.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ||
                    price.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                    return
                }
                
                guard let price = Int(price) else { return }
                let quantity = Double(quantity) ?? 1

                if let expense = expense {
                    vm.update(expense,
                              name: name,
                              category: category,
                              price: price,
                              quantity: quantity,
                              date: date)
                    dismiss()
                } else {
                    vm.add(
                        name: name,
                        category: category,
                        price: price,
                        quantity: quantity,
                        date: date)
                    dismiss()
                }
            }, label: {
                Text("Save")
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.yellow1)
                    .cornerRadius(16)
                    .foregroundColor(.white)
                    .font(.headline)
            })
        }
        .frame(height: 64)
    }
    
    // MARK: Helper functions
    private func populateFields(with expense: Expense) {
        name = expense.name
        price = "\(expense.price)"
        quantity = "\(expense.quantity.removeZerosFromEnd())"
        date = expense.date
    }
}





















































struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        EditorExpenseScreen(vm: ManagerExpense.shared)
    }
}
