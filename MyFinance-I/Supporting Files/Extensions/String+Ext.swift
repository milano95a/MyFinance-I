//
//  String+Ext.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 02/08/24.
//

import Foundation

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
