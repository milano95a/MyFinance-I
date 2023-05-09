
import SwiftUI
import RealmSwift

@main
struct MyFinance_IApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            InitialTabScreen()
                .environment(\.realmConfiguration, Realm.Configuration(schemaVersion: 1))
                .environmentObject(ManagerExpense.shared)
        }
    }
}
