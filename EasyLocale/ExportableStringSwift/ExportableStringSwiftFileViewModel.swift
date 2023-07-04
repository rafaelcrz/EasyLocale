//
//  ExportableStringSwiftFileViewModel.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 03/07/23.
//

import Foundation
import SwiftUI

enum KeyFileType: String {
    case `enum`
    case `struct`
}

enum KeyType: String {
    case `string` = "String"
    case localizedStringKey = "LocalizedStringKey"
}

final class ExportableStringSwiftFileViewModel: ObservableObject {
    @Published var keyFileType: KeyFileType = .struct
    @Published var keyType: KeyType = .localizedStringKey
    @Published var previewStringFile: String = ""
    @Published var exportableLanguages: [ExportableLanguage] = []
    
    private let lProjHelper: LProjHelperProtocol = LProjHelper()
    
    private var localizedExtension: String {
        return """
        extension String {
            func localize(comment: String = "") -> String {
                let defaultLanguage: String = "en"
                let value: String = NSLocalizedString(self, comment: comment)
                
                if value != self || NSLocale.preferredLanguages.first == defaultLanguage {
                    return value
                }
                
                guard let path = Bundle.main.path(forResource: defaultLanguage, ofType: "lproj"), let bundle = Bundle(path: path) else {
                    return value
                }
                
                return NSLocalizedString(self, bundle: bundle, comment: "")
            }
        }
        """
    }
    
    func generateEnumerationStringFile(url: URL?) {
        Dictionary(grouping: exportableLanguages, by: { $0.codeLanguage }).forEach { language, translations in
            var stringsLine: [String] = []
            
            for translation in translations {
                let enumKey: String = translation.key.withoutPunctuations
                switch keyFileType {
                case .struct:
                    stringsLine.append("    static let \(enumKey): \(keyType.rawValue) = \"\(translation.key)\"")
                case .enum:
                    stringsLine.append("    case \(enumKey) = \"\(translation.key)\"")
                }
            }
            
            var content: String = ""
            switch keyFileType {
            case .struct:
                content = """
                 import SwiftUI
                 
                 struct Strings {
                 \(stringsLine.joined(separator: "\n"))
                 }
                 \n
                 \(localizedExtension)
                 """
            case .enum:
                content = """
                 import SwiftUI
                 
                 enum Strings: \(keyType.rawValue) {
                 \(stringsLine.joined(separator: "\n"))
                 }
                 \n
                 \(localizedExtension)
                 """
            }
            
            previewStringFile = content
            
            if let url = url {
                lProjHelper.createSwiftStrings(at: url, fileContent: content)
            }
        }
    }
}

private extension String {
    var withoutPunctuations: String {
        return self.components(separatedBy: CharacterSet.punctuationCharacters)
            .map { $0.capitalized }
            .joined(separator: "")
            .replacingOccurrences(of: " ", with: "")
            .capitalizedSentence
    }
    
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).lowercased()
        let remainingLetters = self.dropFirst()
        return firstLetter + remainingLetters
    }
}
