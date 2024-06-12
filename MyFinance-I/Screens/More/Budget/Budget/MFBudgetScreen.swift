//
//  MFBudgetScreen.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import SwiftUI


struct MFBudgetScreen: View {
    
    @ObservedObject var vm: MFBudgetViewModel    
    
//    @State private var selectedItem: MFBudgetItemDTO?
    @State private var showCreateItemePopup = false
    @State private var showDeleteAlert = false
    
    var body: some View  {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                MFBudgetListHeaderItem(title: "Budget", value: vm.budget())
                    .foregroundColor(Color.weeklyTotalColor)
                    .padding(.horizontal, 16)
                MFBudgetListHeaderItem(title: "Allocated", value: vm.allocated())
                    .foregroundColor(Color.monthlyTotalColor)
                    .padding(.horizontal, 16)
                MFBudgetListHeaderItem(title: "Unbudgeted", value: vm.unbudgeted())
                    .foregroundColor(Color.dailyTotalColor)
                    .padding(.horizontal, 16)
                
                if let parent = vm.parent {
                    List(parent.budgetItem.freeze()) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                            HStack {
                                Text("\(item.amount)")
                                Spacer()
                                Text(vm.percentage(budgetAmount: item.amount))
                            }
                        }
                        .swipeActions {
                            Button("Delete") {
                                vm.selectedItem = item
                                showDeleteAlert = true
                            }.tint(.red)
                            Button("Edit") {
                                vm.selectedItem = item
                                showCreateItemePopup = true
                            }.tint(.blue)
                        }
                    }                    
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .popover(isPresented: $showCreateItemePopup) {
                        return MFBudgetItemEditorScreen()
                            .environmentObject(vm)
                    }
                    .alert("Delete?", isPresented: $showDeleteAlert, presenting: vm.selectedItem, actions: { expense in
                        Button("Delete", action: {
                            if let selectedItem = vm.selectedItem {
                                vm.delete(selectedItem)
                            }
                        })
                        Button("Cancel", role: .cancel, action: { })
                    })
                }
            }
            
            MFFloatingButton {
                vm.clear()
                showCreateItemePopup = true
            }
        }
        .navigationTitle("Budget: \(vm.parent?.date.formatDate(with: "MMM yyyy") ?? "n/a")")
        .toolbar { MFToolbar { } }
        .onAppear {
            vm.load()
        }
    }
}














































































#Preview {
    MFBudgetScreen(vm: .init(parent: .init()))
}
