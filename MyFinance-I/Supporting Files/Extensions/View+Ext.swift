//
//  View+Ext.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 05/06/24.
//

import SwiftUI

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
             .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
    
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
