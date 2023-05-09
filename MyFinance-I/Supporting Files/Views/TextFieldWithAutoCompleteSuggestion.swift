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
            TextField("\(placeholderText)", text: textBinding)
                .textInputAutocapitalization(.never)
                .onChange(of: textBinding.wrappedValue) { newValue in
                    if suggestionSelected {
                        suggestions = []
                        suggestionSelected = false
                    } else if newValue.count > 1 {
                        suggestions = getSuggestions(newValue)
                    } else {
                        suggestions = []
                    }
                }
            
            if suggestions.count > 0 {
                if suggestions.count == 1 {
                    if let suggestion = suggestions[0] as? String, suggestion == textBinding.wrappedValue {
                        // don't show suggestion because user already typed the entire string of one and only suggestion
                    } else {
                        suggestionView
                    }
                } else {
                    suggestionView
                }
            }
        }
    }
    
    var suggestionView: some View {
        ScrollView {
            ForEach(suggestions.indices, id: \.self) { index in
                VStack {
                    Text(getSuggestionText(suggestions[index]))
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .background(Color(uiColor: UIColor.systemGray6))
                .onTapGesture {
                    onSuggestionTap(suggestions[index])
                    suggestionSelected = true
                }
            }
        }
        .frame(maxHeight: min(200, CGFloat(suggestions.count * 50)))

    }

//    // Why I Can't do this
//    struct Constants {
//        static let suggestionListmaxHeight: Int = 200
//
//    }
}
