//
//  Extensions.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 06/04/23.
//

import SwiftUI
import RealmSwift
import Realm


//@discardableResult
//func share(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) -> Bool {
////    for scene in UIApplication.shared.connectedScenes {
////        print("")
////    }
////    guard let source = UIApplication.shared.keyWindow?.rootViewController else {
////        return false
////    }
////    guard let source = UIApplication.shared.windows.last?.rootViewController else {
////        return false
////    }
//    let vc = UIActivityViewController(
//        activityItems: items,
//        applicationActivities: nil
//    )
//    vc.excludedActivityTypes = excludedActivityTypes
//    vc.popoverPresentationController?.sourceView = source.view
//    source.present(vc, animated: true)
//    return true
//}

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

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    func element(at index: Index?) -> Element? {
        if let index {
            return self[safe: index]
        } else {
            return nil
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
