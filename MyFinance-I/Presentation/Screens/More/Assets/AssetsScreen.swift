//
//  AssetAppreciationScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 19/05/23.
//

import SwiftUI
import RealmSwift

struct AssetsScreen: View {
    var items = Realm.shared().objects(Asset.self)
    @State private var showEditor = false
    @State private var name = ""
    @State private var cost = ""
    @State private var date = Date.now
    @State private var isAppreciating = false
    @State private var appreciationOrDepreciationRate = ""
    @FocusState private var focused: Bool?
    
    var body: some View {
        NavigationStack {
            List(items) { item in
                HStack {
                    Text("\(item.name)")
                    Spacer()
                    Text("\(item.cost)")
                }
                .swipeActions {
                    Button("Edit") {
                        showEditor = true
                    }
                    Button("Delete") {
                        Realm.deleteWithTry(item)
                    }
                }
            }
            .popover(isPresented: $showEditor) {
                GenericEditor(
                    title: "Asset Editor",
                    saveAction: {
                        let asset = Asset(
                            name: name,
                            cost: Int(cost) ?? 0,
                            date: date,
                            isAppreciating: isAppreciating,
                            appreciationOrDepreciationRate: Double(appreciationOrDepreciationRate) ?? 0.0)

                        Realm.addWithTry(asset)
                    },
                    content: {
                        TextField("name", text: $name)
                            .focused($focused, equals: true)
                            .onAppear { focused = true }
                        
                        TextField("cost", text: $cost).keyboardType(.numberPad)
                        
                        DatePicker("date", selection: $date, displayedComponents: [.date])
                        
                        Toggle("Is appreciating asset?", isOn: $isAppreciating)
                        
                        TextField("Appreciation/Depreciation Rate", text: $appreciationOrDepreciationRate)
                            .keyboardType(.numbersAndPunctuation)
                    })
            }
            .navigationTitle("Assets")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showEditor = true
                    }, label: {
                        Label("", systemImage: "plus")
                    })
                }
            }

        }
    }
}

struct AssetAppreciation {
    var value: Int
    var change: Double
}

class Asset: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name = ""
    @Persisted var cost = 0
    @Persisted var date = Date.now
    @Persisted var isAppreciating = false
    @Persisted var appreciationOrDepreciationRate = 0.0
    
    override init() {}
    
    init(name: String, cost: Int, date: Date, isAppreciating: Bool, appreciationOrDepreciationRate: Double) {
        self.name = name
        self.cost = cost
        self.date = date
        self.isAppreciating = isAppreciating
        self.appreciationOrDepreciationRate = appreciationOrDepreciationRate
    }
}





















































struct AssetAppreciationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AssetsScreen()
    }
}
