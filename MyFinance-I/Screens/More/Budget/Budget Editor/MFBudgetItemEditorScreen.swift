//
//  MFBudgetEditorScreen.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import SwiftUI

struct MFBudgetItemEditorScreen: View {
    @EnvironmentObject var vm: MFBudgetViewModel
    @FocusState private var focusedField    : FocusedField?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                MFBudgetListHeaderItem(title: "Budget", value: vm.budget())
                    .foregroundColor(Color.weeklyTotalColor)
                MFBudgetListHeaderItem(title: "Allocated", value: vm.allocated())
                    .foregroundColor(Color.monthlyTotalColor)
                MFBudgetListHeaderItem(title: "Unbudgeted", value: vm.unbudgeted())
                    .foregroundColor(Color.dailyTotalColor)                
                
                TextField("name", text: $vm.name)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .amount }
                
                TextField("amount", text: $vm.amount)
                    .focused($focusedField, equals: .amount)
                    .keyboardType(.numberPad)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .amount }
                
                TextField("percentage", text: $vm.percentage)
                    .focused($focusedField, equals: .percentage)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                    
                Spacer()
                
                MFButton("Save") {
                    vm.save()
                    dismiss()
                }
            }
            .padding()
        }
        .onAppear {
            focusedField = .name
        }
    }
}

extension MFBudgetItemEditorScreen {
    enum FocusedField: Hashable {
        case amount, name, percentage
    }
}




























//#Preview {
//    MFBudgetItemEditorScreen(parent: .init(), item: nil)
//        .environmentObject(MFBudgetItemEditorViewModel())
//}
