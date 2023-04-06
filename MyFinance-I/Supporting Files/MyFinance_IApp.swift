
import SwiftUI
import RealmSwift

@main
struct MyFinance_IApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ExpenseScreen(vm: ExpenseViewModel())
                .environment(\.realmConfiguration, Realm.Configuration(schemaVersion: 1))
        }
    }
}
