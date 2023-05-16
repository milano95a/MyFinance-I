//
//  SavingsEditor.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 12/05/23.
//

import SwiftUI

struct SavingsEditor: View {
    
    @EnvironmentObject var manager: SavingsManager
    var item: Saving?
    @State private var amount = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                form
                saveButton
            }
            .navigationTitle("Saving Editor")
        }
    }
    
    var form: some View {
        Form {
            TextField("amount", text: $amount).keyboardType(.numberPad)
            DatePicker("date", selection: $date, displayedComponents: [.date])
        }
    }
    
    var saveButton: some View {
        GeometryReader { geometry in
            Button(action: {
                // TODO: validate
                manager.create(date, Int(amount) ?? 0)
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
}

struct SavingsEditor_Previews: PreviewProvider {
    static var previews: some View {
        SavingsEditor()
    }
}
