//
//  TextFieldWithAutoCompleteSuggestion.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 08/04/23.
//

import SwiftUI

struct TextFieldWithAutoCompleteSuggestion<T>: View {
    @State private var suggestionSelected = false
    @State private var suggestions = [T]()
    
    var getSuggestions: (String) -> [T]
    var placeholderText: String
    var textBinding: Binding<String>
    var onSuggestionTap: (T) -> Void
    var getSuggestionText: (T) -> String
    
    var body: some View {
        VStack {
            TextField("\(placeholderText)", text: textBinding).onChange(of: textBinding.wrappedValue) { newValue in
                if suggestionSelected {
                    suggestions = []
                    suggestionSelected = false
                } else if newValue.count > 2 {
                    suggestions = getSuggestions(newValue)
                } else {
                    suggestions = []
                }
            }
            
            if suggestions.count > 0 {
                ScrollView {
                    ForEach(suggestions.indices, id: \.self) { index in
                        Text(getSuggestionText(suggestions[index])).onTapGesture {
                            onSuggestionTap(suggestions[index])
                            suggestionSelected = true
                        }
                    }
                }.frame(maxHeight: 200)
            }
        }
    }

//    // Why I Can't do this
//    struct Constants {
//        static let suggestionListmaxHeight: Int = 200
//
//    }
}
