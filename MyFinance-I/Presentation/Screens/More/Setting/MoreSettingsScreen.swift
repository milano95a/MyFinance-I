//
//  MoreSettingsScreen.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import SwiftUI

struct MoreSettingsScreen: View {
    
    @EnvironmentObject var exportManager: ExportManager
    @EnvironmentObject var importManager: ImportManager
    @State private var showImportJsonPopup = false
    
    var body: some View {
        Form {
            Button("Export") {
                if let url = exportManager.exportData() {
                    share(items: [url])
                }
            }
            Button("Import") {
                showImportJsonPopup = true
            }
        }
        .jsonFileImporter(ExportData.self, isPresented: $showImportJsonPopup) { data in
            importManager.importData(data)
        }
    }
}
















#Preview {
    MoreSettingsScreen()
}
