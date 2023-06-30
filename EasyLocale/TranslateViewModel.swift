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
    @Published var currentFile: String = ""
    @Published var progress: Double = 0.0
    @Published var numberOfFiles: Int = 0
    @Published var numberOfLines: Int = 0
        
    private let languageWrapper: LanguageWrapper = LanguageWrapper()
    
    init() {
        availableLanguages = languageWrapper.fetchAvailableLanguages()
        selectedLanguage = availableLanguages.first?.localeIdentifier ?? ""
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
            
            if let index = exportableLanguages.firstIndex(where: { $0.key == exportable.key && $0.codeLanguage == exportable.codeLanguage && $0.value != exportable.value }) {
                exportableLanguages[index] = exportable
            } else {
                exportableLanguages.append(exportableLanguage)
            }
        }
        
    }
    
    func importStringLanguage(urls: [URL]?) {
        
        guard let urls = urls else {
            return
        }
        
        numberOfFiles = urls.count
        
        DispatchQueue.global(qos: .userInitiated).async {
            for url in urls {
                DispatchQueue.main.async {
                    self.progress = 0
                }
                do {
                    let fullContent: String = try String(contentsOf: url)
                    let stringFileName: String = (url.lastPathComponent as NSString).deletingPathExtension
                    let lines: [String] = fullContent.components(separatedBy: .newlines)

                    DispatchQueue.main.async {
                        self.numberOfLines = lines.count
                    }
                    
                    lines
                        .forEach { line in
                            guard !line.isEmpty else {
                                print("==> ERRO ", line, stringFileName)
                                return
                            }
                            
                            let pair: [String] = line
                                .replacingOccurrences(of: "\"", with: "", options: .literal)
                                .components(separatedBy: "=")
                            
                            let country: Language? = self.languageWrapper.fetchAvailableLanguages().first(where: {
                                return $0.localeIdentifier == stringFileName
                            })
                            //caso onde só tenha a chave e nao o valor
                            guard let key = pair.object(index: 0), let value = pair.object(index: 1) else {
                                print("==> ERRO ", line)
                                return
                            }
                            
                            DispatchQueue.main.async {
                                self.progress += 1
                            }
                            
                            let exportableLanguage: ExportableLanguage = .init(
                                key: key,
                                value: self.saniitedValueIfNeeded(value),
                                codeLanguage: stringFileName,
                                descriptionLanguage: ("\(Locale(identifier: "pt_BR").localizedString(forLanguageCode: stringFileName) ?? "nullo") - \(country?.description ?? "")")
                            )
                            //                    descriptionLanguage: ("\(Locale(identifier: "pt_BR").localizedString(forLanguageCode: stringFileName) ?? "nullo") - \(Locale(identifier: "pt-BR").localizedString(forRegionCode: stringFileName) ?? "nullo")")
                            guard !self.exportableLanguages.contains(where: { $0.key == key && $0.codeLanguage == stringFileName }) else {
                                return
                            }
                            
                            DispatchQueue.main.async {
                                self.exportableLanguages.append(exportableLanguage)
                            }
                        }
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    func saniitedValueIfNeeded(_ value: String) -> String {
        var saniitedString: String = value
        
        if value.last == ";" {
            saniitedString = String(value.dropLast())
        }
        
        if value.first == " " {
            saniitedString = String(saniitedString.dropFirst())
        }
        
        return saniitedString
    }
    
    func exportStringLanguage(url: URL?) {
        guard let url = url else {
            return
        }
        
        let languageGroup: [String: [ExportableLanguage]] = Dictionary(grouping: exportableLanguages, by: {
            return $0.codeLanguage
        })
        
        languageGroup.forEach { language, translations in
            var lines: [String] = []
            
            for translation in translations {
                lines.append("\"\(translation.key)\"= \"\(translation.value)\";")
            }
            
            let content: String = lines.joined(separator: "\n")
            createStringFile(path: url, fileName: language, content: content)
        }
    }
    
    func exportableGroupedByKey() -> [String: [ExportableLanguage]] {
        return Dictionary(grouping: exportableLanguages) { exportable in
            return exportable.key
        }
    }
    
    func exportableGroupedByCode() -> [String: [ExportableLanguage]] {
        return Dictionary(grouping: exportableLanguages) { exportable in
            return exportable.codeLanguage
        }
    }
    
    func getLocalizedString(forLanguage language: Language) -> String {
        return "\(language.description) \(language.localeIdentifier)"
    }
    
    func deleteTransalation(_ translation: ExportableLanguage) {
        exportableLanguages.removeAll {
            return $0.key == translation.key && $0.codeLanguage == translation.codeLanguage
        }
    }
    
    func editTransaction(_ translation: ExportableLanguage) {
        currentKey = translation.key
        selectedLanguage = translation.codeLanguage
        languagesToExport.append(translation)
    }
    
    func shouldShowProgressView() -> Bool {
        return progress > 0
    }
    
    private func createStringFile(path: URL, fileName: String, content: String) {
        do {
            let filePath: URL = path.appendingPathComponent("\(fileName).strings")
            try content.write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension Array {
    func object(index: Int) -> Element? {
        if index >= 0 && index < self.count {
            return self[index]
        }
        
        return nil
    }
}
