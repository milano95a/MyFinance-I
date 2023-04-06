//
//  SwiftUIView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 06/04/23.
//

import SwiftUI

struct ExpenseEditorView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm: ExpenseViewModel
    var expense: Expense?
    
    @State private var name = ""
    @State private var price = ""
    @State private var quantity = ""
    @State private var date = Date()
    
    var body: some View {
        VStack {
            expenseForm
            saveButton
        }.onAppear {
            if let expense = expense {
                populateFields(with: expense)
            }
        }
    }
    
    var expenseForm: some View {
        Form {
            TextField("name", text: $name)
            TextField("price", text: $price).keyboardType(.numberPad)
            TextField("quantity", text: $quantity).keyboardType(.decimalPad)
            DatePicker("date", selection: $date, displayedComponents: [.date])
        }
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
    
    // MARK: Helper functions
    
    private func resetFields() {
        name = ""
        price = ""
        quantity = ""
    }
    
    private func populateFields(with expense: Expense) {
        name = expense.name
        price = "\(expense.price)"
        quantity = "\(expense.quantity.removeZerosFromEnd())"
        date = expense.date
    }
}




















































struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseEditorView(vm: ExpenseViewModel())
    }
}
