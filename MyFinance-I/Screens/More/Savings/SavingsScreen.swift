//
//  SavingsScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 12/05/23.
//

import SwiftUI

struct SavingsScreen: View {
    @EnvironmentObject var manager: SavingsManager
    @State var showEditor = false
    @State var selectedItem: Saving?
    
    var body: some View {
        NavigationStack {
            List(manager.items.freeze()) { item in
                SavingItemView(item: item, change: manager.change(for: item))
                    .swipeActions {
                        Button("Delete") {
                            manager.delete(item)
                        }.tint(.red)
                        Button("Edit") {
                            selectedItem = item
                            showEditor = true
                        }.tint(.blue)
                    }
            }
            .navigationTitle("Savings")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showEditor = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .popover(isPresented: $showEditor) { [selectedItem] in
                if let saving = selectedItem {
                    SavingsEditor(item: saving)
                } else {
                    SavingsEditor()
                }
            }
        }
    }
}

struct SavingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavingsScreen()
            .environmentObject(SavingsManager())
    }
}
