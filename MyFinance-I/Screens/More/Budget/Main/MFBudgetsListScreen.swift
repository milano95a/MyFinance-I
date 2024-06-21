//
//  MFBudgetScreen.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import SwiftUI
import RealmSwift

class MFBudgetItemDTO: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var amount: Int = 0
    
    func update(_ name: String?, _ amount: Int?) {
        self.writeToDB { thawedObj, thawedRealm in
            if let item = thawedObj as? MFBudgetItemDTO {
                if let name {
                    item.name = name
                }
                if let amount {
                    item.amount = amount
                }
            }
        }
    }
}

class MFBudgetDTO: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date = Date()
    @Persisted var amount: Int = 0
    @Persisted var budgetItem: RealmSwift.List<MFBudgetItemDTO>
    
    func update(_ amount: Int, _ date: Date) {
        self.writeToDB { thawedObj, thawedRealm in
            if let item = thawedObj as? MFBudgetDTO {
                item.amount = amount
                item.date = date
            }
        }
    }
    
    func append(_ child: MFBudgetItemDTO) {
        self.writeToDB { thawedObj, thawedRealm in
            if let item = thawedObj as? MFBudgetDTO {
                item.budgetItem.append(child)
            }
        }
    }
}

struct MFBudgetsListEditorScreen: View {
    
    enum FocusedField: Hashable {
        case amount
    }

    @EnvironmentObject var vm: MFBudgetsListViewModel
    var item: MFBudgetDTO?
    
    @State private var amount               : String
    @State private var date                 : Date
    @FocusState private var focusedField    : FocusedField?
    @Environment(\.dismiss) var dismiss
    
    init(item: MFBudgetDTO? = nil) {
        self.item = item
        
        if let item {
            self._amount    = State(initialValue: String(item.amount))
            self._date      = State(initialValue: item.date)
        } else {
            self._amount    = State(initialValue: "")
            self._date      = State(initialValue: Date())
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("amount", text: $amount)
                    .focused($focusedField, equals: .amount)
                    .keyboardType(.numberPad)
                DatePicker("date", selection: $date, displayedComponents: [.date])
                
                Spacer()
                
                Button("Save") {
                    if let item {
                        vm.update(item, Int(amount) ?? 0, date)
                    } else {
                        let item = MFBudgetDTO()
                        item.amount = Int(amount) ?? 0
                        item.date = date
                        vm.save(item)
                    }
                    dismiss()
                }
            }.onAppear {
                focusedField = .amount
            }.padding()
        }
    }
}

struct MFBudgetsListScreen: View {
    
    @EnvironmentObject var vm: MFBudgetsListViewModel
    @State private var selectedItem: MFBudgetDTO?
    @State private var showDeleteAlert = false
    @State private var showCreateItemePopup = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            list
            MFFloatingButton {
                selectedItem = nil
                showCreateItemePopup = true
            }
        }
        .navigationTitle("Budgets")
        .toolbar { MFToolbar { } }
    }
    
    @ViewBuilder
    var list: some View {
        List(vm.items.freeze()) { item in
            NavigationLink(destination: MFBudgetScreen(vm: MFBudgetViewModel(parent: item))) {
                VStack(alignment: .leading) {
                    Text("Budget: \(item.date.formatDate(with: "MMM yyyy") ?? "n/a")")
                    Text("\(item.amount)")
                }
                .swipeActions {
                    Button("Delete") {
                        selectedItem = item
                        showDeleteAlert = true
                    }.tint(.red)
                    Button("Edit") {
                        selectedItem = item
                        showCreateItemePopup = true
                    }.tint(.blue)
                }
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .popover(isPresented: $showCreateItemePopup) { [selectedItem] in
            MFBudgetsListEditorScreen(item: selectedItem)
        }
        .alert("Delete?", isPresented: $showDeleteAlert, presenting: selectedItem, actions: { expense in
            Button("Delete", action: {
                if let selectedItem {
                    vm.delete(selectedItem)
                }
            })
            Button("Cancel", role: .cancel, action: { })

        })
    }
}















































































#Preview {
    NavigationStack {
        MFBudgetsListScreen()
            .environmentObject(MFBudgetsListViewModel())
    }
}
