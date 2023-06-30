//
//  Array+Extensions.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 30/06/23.
//

import Foundation

extension Array {
    func object(index: Int) -> Element? {
        if index >= 0 && index < self.count {
            return self[index]
        }
        
        return nil
    }
}
