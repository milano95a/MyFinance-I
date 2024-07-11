import SwiftUI
import RealmSwift
import Combine

struct EditorExpenseScreen: View {
    
    enum FocusedField: Hashable {
        case name, category, price, quantity, cost
    }
    
    var expense: Expense?
    @EnvironmentObject var manager: MFExpenseViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: FocusedField?
    @State private var name: String
    @State private var nameFieldIsFocused = false
    @State private var category: String
    @State private var categoryFieldIsFocused = false
    @State private var cost: String
    @State private var price: String
    @State private var quantity: String
    @State private var date: Date
    
    var body: some View {
        VStack {
            expenseForm
            Spacer()
            saveButton
        }
        .padding()
        .onAppear {
            focusedField = .name
            nameFieldIsFocused = true
        }
    }
}

extension EditorExpenseScreen {
    
    init(expense: Expense? = nil) {
        self.expense = expense
        if let expense {
            self._name = State(initialValue: expense.name)
            self._price = State(initialValue: String(expense.price))
            self._quantity = State(initialValue: String(expense.quantity))
            self._cost = State(initialValue: String(expense.cost))
            self._date = State(initialValue: expense.date)
            self._category = State(initialValue: expense.category)
        } else {
            self._name = State(initialValue: "")
            self._price = State(initialValue: "")
            self._quantity = State(initialValue: "")
            self._date = State(initialValue: Date())
            self._category = State(initialValue: "")
            self._cost = State(initialValue: "")
        }
        
        
    }

    var expenseForm: some View {
        VStack {
            nameTextFieldWithAutoCompleteSuggestion
            
            cateogryTextFieldWithAutoCompleteSuggestion
            
            priceTextField
            
            quantityTextField
            
            costTextField

            datePicker
        }
    }
        
    var nameTextFieldWithAutoCompleteSuggestion: some View {
        TextFieldWithAutoCompleteSuggestion<Expense>(
            getSuggestions: { typedText in
                return manager.getSuggestions(with: typedText)
            },
            placeholderText: "name",
            textBinding: $name,
            onSuggestionTap: { expense in
                name = expense.name
                category = expense.category
                price = "\(expense.price)"
                quantity = "\(expense.quantity)"
                cost = String(Int(Double(expense.price) * expense.quantity))
            },
            getSuggestionText: { expense in
                expense.name
            },
            fieldIsFocused: $nameFieldIsFocused
        )
        .focused($focusedField, equals: .name)
        .submitLabel(.next)
        .onSubmit {
            focusedField = .category
            nameFieldIsFocused = false
            categoryFieldIsFocused = true
        }
        .selectAllTextOnEditing()
        .font(.title2)
    }
    
    var cateogryTextFieldWithAutoCompleteSuggestion: some View {
        TextFieldWithAutoCompleteSuggestion<String>(
            getSuggestions: { typedText in
                Array(manager.getCategorySuggestions(with: typedText))
            },
            placeholderText: "cateogry",
            textBinding: $category,
            onSuggestionTap: { category in
                self.category = category
            },
            getSuggestionText: { category in
                category
            },
            fieldIsFocused: $categoryFieldIsFocused
        )
        .focused($focusedField, equals: .category)
        .submitLabel(.next)
        .onSubmit {
            focusedField = .price
            categoryFieldIsFocused = false
        }
        .selectAllTextOnEditing()
        .font(.title2)
    }
    
    var priceTextField: some View {
        TextField("price", text: $price)
            .keyboardType(.numbersAndPunctuation)
            .focused($focusedField, equals: .price)
            .submitLabel(.next)
            .onSubmit { focusedField = .quantity }
            .selectAllTextOnEditing()
            .font(.title2)
            .onChange(of: price) { newValue in
                if focusedField == .price {
                    if let quantity = Double(quantity), let price = Double(price) {
                        cost = String(Int(quantity * price))
                    }
                    else if let cost = Double(cost), let price = Double(price) {
                        guard price > 0 else { return }
                        quantity = String(cost / price)
                    }
                }
            }
    }

    var quantityTextField: some View {
        TextField("quantity", text: $quantity)
            .keyboardType(.numbersAndPunctuation)
            .focused($focusedField, equals: .quantity)
            .onSubmit { focusedField = .cost }
            .submitLabel(.next)
            .selectAllTextOnEditing()
            .font(.title2)
            .onChange(of: quantity) { newValue in
                if focusedField == .quantity {
                    if let cost = Double(cost), let quantity = Double(quantity) {
                        guard quantity > 0 else { return }
                        price = String(Int(cost / quantity))
                    }
                    else if let quantity = Double(quantity), let price = Double(price) {
                        cost = String(Int(quantity * price))
                    }
                }
            }
    }
    
    var costTextField: some View {
        TextField("cost", text: $cost)
            .keyboardType(.numbersAndPunctuation)
            .focused($focusedField, equals: .cost)
            .submitLabel(.done)
            .selectAllTextOnEditing()
            .font(.title2)
            .onChange(of: cost) { newValue in
                if focusedField == .cost {
                    if let cost = Double(cost), let quantity = Double(quantity) {
                        guard quantity > 0 else { return }
                        price = String(Int(cost / quantity))
                    }
                    else if let cost = Double(cost), let price = Double(price) {
                        guard price > 0 else { return }
                        quantity = String(cost / price)
                    }
                }
            }
    }
    
    var datePicker: some View {
        DatePicker("date", selection: $date, displayedComponents: [.date])
            .font(.title2)
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
                    manager.update(expense,
                              name: name,
                              category: category,
                              price: price,
                              quantity: quantity,
                              date: date)
                    dismiss()
                } else {
                    manager.add(
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
        EditorExpenseScreen()
    }
}
