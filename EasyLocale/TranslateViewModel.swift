//
//  TranslateViewModel.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 27/06/23.
//

import Foundation

final class TranslateViewModel: ObservableObject {
    @Published var languagesToExport: [ExportableLanguage] = []
    
    // MARK: - Publshiers
    @Published var selectedLanguage: String = ""
    @Published var availableLanguages: [Language] = []
    @Published var currentKey: String = ""
    
    @Published var exportableLanguages: [ExportableLanguage] = []
    
    private let languageWrapper: LanguageWrapper = LanguageWrapper()
    
    init() {
        availableLanguages = languageWrapper.fetchAvailableLanguages()
    }
    
    func addNewLanguage() {
        guard let language: Language = availableLanguages.first(where: { $0.localeIdentifier == selectedLanguage }) else {
            return
        }
        
        guard !languagesToExport.contains(where: { $0.codeLanguage == selectedLanguage }) else {
            return
        }
        
        let exportableLanguage: ExportableLanguage = .init(
            key: currentKey,
            value: "",
            codeLanguage: language.localeIdentifier,
            descriptionLanguage: language.description
        )
        
        languagesToExport.append(exportableLanguage)
    }
    
    func addKeyStringToStringsFile() {
        for exportable in languagesToExport {
            let exportableLanguage: ExportableLanguage = .init(
                key: currentKey,
                value: exportable.value,
                codeLanguage: exportable.codeLanguage,
                descriptionLanguage: exportable.descriptionLanguage
            )
            
            exportableLanguages.append(exportableLanguage)
        }
        
    }
    
    func exportStringLanguage() {
        
    }
    
    func exportableGroupedByKey() -> [String: [ExportableLanguage]] {
        return Dictionary(grouping: exportableLanguages) { exportable in
            return exportable.key
        }
    }
    
    func getLocalizedString(forLanguage language: Language) -> String {
        return "\(language.description) \(language.localeIdentifier)"
    }
}
