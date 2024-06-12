//
//  Extensions.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 06/04/23.
//

import SwiftUI
import RealmSwift
import Realm

extension RealmSwiftObject {
    func addToDB() {
        Realm.writeWithTry { realm in
            realm.add(self)
        }
    }
    
    func deleteFromDB() {
        self.writeToDB { thawedObj, thawedRealm in
            thawedRealm.delete(thawedObj)
        }
    }
    
    func writeToDB(_ callback: (RealmSwiftObject, Realm) -> Void) {
        guard let thawedObj = self.thaw() else { return }
        assert(thawedObj.isFrozen == false)
        guard let thawedRealm = thawedObj.realm else { return }
        do {
            try thawedRealm.write {
                callback(thawedObj, thawedRealm)
            }
        } catch let error {
            print(error)
        }
    }
}

extension Array where Element: RealmSwiftObject {
    func addToDB() {
        Realm.writeWithTry { realm in
            realm.add(self)
        }
    }
}
extension ObjectId {
    func findById<T: RealmSwiftObject>() -> T? {
        Realm.shared().object(ofType: T.self, forPrimaryKey: self)
    }
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}

extension Realm {
    // TODO: use this shared instance everywhere 
    static func shared() -> Realm {
        let configuration = Realm.Configuration(schemaVersion: 6)
        Realm.Configuration.defaultConfiguration = configuration
        let realm = try! Realm()
        return realm
    }
    
    static func writeWithTry(_ callback: (Realm) -> Void ) {
        do {
            let realm = try Realm()
            try realm.write {
                callback(realm)
            }
        } catch let error {
            print(error)
        }
    }
    
    static func deleteWithTry(_ object: Object) {
        Realm.writeWithTry { realm in
            realm.delete(object)
        }
    }
    
    static func addWithTry(_ object: Object) {
        Realm.writeWithTry { realm in
            realm.add(object)
        }
    }
    
    static func deleteAll() {
        Realm.writeWithTry { realm in
            realm.deleteAll()
        }
    }
    
    static func fetchRequest<Element: RealmFetchable>(_ predicate: NSPredicate) -> Results<Element> {
        return Realm.shared().objects(Element.self)
    }
}

extension View {
    func jsonFileImporter<T: Codable>(_ someType: T.Type, isPresented: Binding<Bool>, _ callback: @escaping (T) -> Void) -> some View {
        self.fileImporter(isPresented: isPresented, allowedContentTypes: [.json], allowsMultipleSelection: false) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let urls):
                if urls[0].startAccessingSecurityScopedResource() {
                    defer { urls[0].stopAccessingSecurityScopedResource() }
                    let data = try! Data(contentsOf: urls[0])
                    let items = try! JSONDecoder().decode(someType, from: data)
                    callback(items)
                } else {
                    print("Failed to decode from JSON")
                }
            }
        }
    }
}

extension Date {
    var dayOfTheYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
    
    var weekOfTheYear: Int {
        Calendar.current.component(.weekOfYear, from: self)
    }
    
    var monthOfTheYear: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var friendlyDate: String {
        self.formatted(date: .abbreviated, time: .omitted)
    }
    
    func isSameWeek(_ date: Date) -> Bool {
        self.weekOfTheYear == date.weekOfTheYear && self.year == date.year
    }
    
    func isSameDay(_ date: Date) -> Bool {
        return self.dayOfTheYear == date.dayOfTheYear && self.year == date.year
    }
    
    func isSameMonth(_ date: Date) -> Bool {
        self.monthOfTheYear == date.monthOfTheYear && self.year == date.year
    }
    
    func monthsSince(_ date: Date) -> [Date] {
        var result = [Date]()
        var nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: date)!

        while nextMonth < Date.now {
            result.append(nextMonth)
            nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: nextMonth)!
        }
                    
        return result
    }
    
    /// Converts date inito string with custom format
    func formatDate(with format: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func dropFirstWord() -> String {
        if self.count > self.firstWord().count {
            return String(self.dropFirst(self.firstWord().count))
        } else {
            return self
        }
    }
    
    func firstWord() -> String {
        var word = ""
        for char in self {
            if char == " " {
                return word
            } else {
                word.append(char)
            }
        }
        return self
    }
}

@discardableResult
func share(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) -> Bool {
    guard let source = UIApplication.shared.windows.last?.rootViewController else {
        return false
    }
    let vc = UIActivityViewController(
        activityItems: items,
        applicationActivities: nil
    )
    vc.excludedActivityTypes = excludedActivityTypes
    vc.popoverPresentationController?.sourceView = source.view
    source.present(vc, animated: true)
    return true
}

extension Color {
    static var defaultTextColor = Color(uiColor: .darkGray)
    static var yearlyTotalColor = Color.yellow1
    static var monthlyTotalColor = Color.green1
    static var weeklyTotalColor = Color.blue1
    static var dailyTotalColor = Color.pink1
    static var addButtonColor = Color.yellow1
    
    static var blue1 = Color(red: 0/255, green: 172/255, blue: 234/255)
    static var pink1 = Color(red: 255/255, green: 51/255, blue: 153/255)
    static var green1 = Color(red: 0/255, green: 255/255, blue: 204/255)
    static var yellow1 = Color(red: 254/255, green: 219/255, blue: 65/255)
}

extension UIColor {
    
    static var mainBackground: UIColor { UIColor(0x00ACEA) }
    static var monthTextColor: UIColor { UIColor(0x00ffcc) }
    static var weekTextColor: UIColor { UIColor(0x00ACEA) }
    
    static var lightBlack: UIColor { UIColor(0x333333) }
    static var expanded: UIColor { UIColor(0x191919) }
    static var statusBar: UIColor { UIColor(0x083863) }

    static var scrollBackground: UIColor { UIColor(0x111111) }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(_ rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Array {
    var lastIndex: Int {
        self.count - 1
    }
}

public struct SelectAllTextOnEditingModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                if let textField = obj.object as? UITextField {
                    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                }
            }
    }
}

extension View {

    /// Select all the text in a TextField when starting to edit.
    /// This will not work with multiple TextField's in a single view due to not able to match the selected TextField with underlying UITextField
    public func selectAllTextOnEditing() -> some View {
        modifier(SelectAllTextOnEditingModifier())
    }
}

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
    static func contains(field: String, _ string: String) -> NSPredicate {
        NSPredicate(format: "\(field) CONTAINS[c] '\(string)'")
    }
    static func equals(field: String, equalsTo string: ObjectId) -> NSPredicate {
        NSPredicate(format: "\(field) == \(string)")
    }
}
