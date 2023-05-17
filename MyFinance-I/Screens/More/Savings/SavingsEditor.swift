//
//  SavingsEditor.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 12/05/23.
//

import SwiftUI

struct SavingsEditor: View {
    
    @EnvironmentObject var manager: SavingsManager
    @Environment(\.dismiss) var dismiss
    var item: Saving?
    @State private var amount = ""
    @State private var date = Date()
    @FocusState private var amountFocused: Bool?
    
    var body: some View {
        GenericEditor(title: "Savings Editor", saveAction: {
            if let item = item {
                manager.update(item, date, Int(amount) ?? 0)
            } else {
                manager.create(date, Int(amount) ?? 0)
            }
            dismiss()
        }, content: {
            TextField("amount", text: $amount)
                .keyboardType(.numberPad)
                .focused($amountFocused, equals: true)
                .onAppear {
                    amountFocused = true
                }
            DatePicker("date", selection: $date, displayedComponents: [.date])
        }).onAppear {
            if let item = item {
                amount = String(item.amount)
                date = item.date
            }
        }
    }
}

struct SavingsEditor_Previews: PreviewProvider {
    static var previews: some View {
        SavingsEditor()
    }
}
