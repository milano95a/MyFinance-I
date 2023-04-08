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
