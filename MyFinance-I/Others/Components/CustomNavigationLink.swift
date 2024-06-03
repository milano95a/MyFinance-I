//
//  CustomNavigationLink.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 18/05/23.
//

import SwiftUI

struct CustomNavigationLink<Destination>: View where Destination: View {
    var label: LocalizedStringKey
    var desitination: Destination

    init(_ label: LocalizedStringKey, destination: Destination) {
        self.label = label
        self.desitination = destination
    }

    var body: some View {
        NavigationLink(label, destination: desitination)
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
}
