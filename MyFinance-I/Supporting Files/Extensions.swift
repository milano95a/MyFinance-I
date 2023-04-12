//
//  Extensions.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 06/04/23.
//

import SwiftUI
import RealmSwift

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
    static let shared = try! Realm()
    
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
//        Calendar.current.component(.day, from: self)
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
