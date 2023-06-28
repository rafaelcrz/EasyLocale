//
//  LanguageWrapper.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 27/06/23.
//

import Foundation

final class LanguageWrapper {
    func fetchAvailableLanguages() -> [Language] {
        guard let path = Bundle.main.path(forResource: "languages", ofType: "json") else {
            return []
        }
        
        do {
            let data: Data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
            return try JSONDecoder().decode([Language].self, from: data)
                .sorted(by: { $0.description < $1.description })
        } catch {
            return []
        }
    }
}
