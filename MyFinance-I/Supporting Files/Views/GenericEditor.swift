//
//  GenericEditor.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 16/05/23.
//

import SwiftUI

struct GenericEditor<Content>: View where Content : View {
    
    var content: Content
    var title: String
    var saveAction: () -> Void
    
    init(title: String, saveAction: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.title = title
        self.saveAction = saveAction
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                content
            }
            .navigationTitle("\(title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        saveAction()
                    }, label: {
                        Text("Save")
                    })
                }
            }
        }
    }
}

struct GenericEditor_Previews: PreviewProvider {

    static var previews: some View {
        @State var amount = ""
        @State var date = Date()

        GenericEditor(
            title: "Generic Editor",
            saveAction: {
                
            },
            content: {
                TextField("amount", text: $amount).keyboardType(.numberPad)
                DatePicker("date", selection: $date, displayedComponents: [.date])
            })
    }
}
