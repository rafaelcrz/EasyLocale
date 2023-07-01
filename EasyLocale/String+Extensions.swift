//
//  String+Extensions.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 30/06/23.
//

import Foundation

extension String {
    var sanitizedValueIfNeeded: String {
        var saniitedString: String = self
        
        if self.last == ";" {
            saniitedString = String(self.dropLast())
        }
        
        if self.first == " " {
            saniitedString = String(saniitedString.dropFirst())
        }
        
        return saniitedString
    }
}
