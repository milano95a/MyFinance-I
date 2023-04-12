//
//  SwiftUIView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 06/04/23.
//

import SwiftUI
import RealmSwift

struct ExpenseEditorScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm: ExpenseManager
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
            saveButton
        }.padding()
    }
}

extension ExpenseEditorScreen {
    
    enum FocusedField: Hashable {
        case name, category, price, quantity
    }
    
    init(vm: ExpenseManager, expense: Expense? = nil) {
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
            
            cateogryTextFieldWithAutoCompleteSuggestion
                .focused($focusedField, equals: .category)
                .submitLabel(.next)
                .onSubmit { focusedField = .price }

            TextField("price", text: $price).keyboardType(.numbersAndPunctuation)
                .focused($focusedField, equals: .price)
                .submitLabel(.next)
                .onSubmit { focusedField = .quantity }

            TextField("quantity", text: $quantity).keyboardType(.numbersAndPunctuation)
                .focused($focusedField, equals: .quantity)
                .submitLabel(.done)

            DatePicker("date", selection: $date, displayedComponents: [.date])
            
            Spacer()
        }.onAppear {
            focusedField = .name
        }
    }
    
    var nameTextFieldWithAutoCompleteSuggestion: some View {
        TextFieldWithAutoCompleteSuggestion<Expense>(
            getSuggestions: { typedText in
                Array(vm.getSuggestions(with: typedText))
            },
            placeholderText: "name",
            textBinding: $name,
            onSuggestionTap: { expense in
                name = expense.name
                price = "\(expense.price)"
                quantity = "\(expense.quantity)"
                date = expense.date
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
            getSuggestionText: { cateogry in
                cateogry
            })
    }
    
    var saveButton: some View {
        Button("Save") {
            // TODO: validate
            // TODO: I want number keyboard for price and quantity
            let price = Int(price)!
            let quantity = Double(quantity)!

            if let expense = expense {
                vm.update(expense,
                          name: name,
                          price: price,
                          quantity: quantity,
                          date: date)
                dismiss()
            } else {
                vm.add(
                    name: name,
                    price: price,
                    quantity: quantity,
                    date: date)
                resetFields()
            }
        }
    }

    private func resetFields() {
        name = ""
        price = ""
        quantity = ""
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
        ExpenseEditorScreen(vm: ExpenseManager.shared)
    }
}
