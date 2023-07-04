//
//  TranslateViewModel.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 27/06/23.
//

import Foundation

final class TranslateViewModel: ObservableObject {
    private let aplicationLocale: String = "en"
    
    // MARK: - Publshiers
    @Published var languagesToEdit: [ExportableLanguage] = []
    @Published var selectedLanguage: String = ""
    @Published var availableLanguages: [Language] = []
    @Published var currentKey: String = ""
    @Published var exportableLanguages: [ExportableLanguage] = []
    @Published var currentFile: String = ""
    @Published var progress: Double = 0.0
    @Published var numberOfFiles: Int = 0
    @Published var numberOfLines: Int = 0
    @Published var previewStringFile: String = ""
    
    private let lProjHelper: LProjHelperProtocol = LProjHelper()
    private let languageWrapper: LanguageWrapper = LanguageWrapper()
    
    init() {
        availableLanguages = languageWrapper.fetchAvailableLanguages()
        selectedLanguage = availableLanguages.first?.localeIdentifier ?? ""
    }
    
    private func resetData() {
        currentKey = ""
        languagesToEdit = []
    }
    
    func addNewLanguageToTranslation() {
        guard let language: Language = availableLanguages.first(where: { $0.localeIdentifier == selectedLanguage }) else {
            return
        }
        
        guard !languagesToEdit.contains(where: { $0.codeLanguage == language.localeIdentifier }) else {
            return
        }
        
        let exportableLanguage: ExportableLanguage = .init(
            key: currentKey,
            value: "",
            codeLanguage: language.localeIdentifier,
            descriptionLanguage: language.description
        )
        
        languagesToEdit.append(exportableLanguage)
    }
    
    func updateStringsFileWithCurrentKeyValue() {
        for exportable in languagesToEdit {
            let exportableLanguage: ExportableLanguage = .init(
                key: currentKey,
                value: exportable.value,
                codeLanguage: exportable.codeLanguage,
                descriptionLanguage: exportable.descriptionLanguage
            )
            
            if let index = exportableLanguages.firstIndex(where: { $0.id == exportable.id }), index > 0, index < exportableLanguages.count {
                exportableLanguages[index] = exportableLanguage
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
                    var stringFileName: String?
                    var fullContent: String?
                    let isDirectory: Bool = try url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false
                    
                    if isDirectory {
                        let enumerator = FileManager.default.enumerator(atPath: url.relativePath)
                        let filePaths = enumerator?.allObjects as! [String]
                        let textFilePaths = filePaths.filter { $0.contains(".strings") }
                        for textFilePath in textFilePaths {
                            if let path = URL(string: url.absoluteString + textFilePath) {
                                fullContent = try String(contentsOf: path)
                                stringFileName = self.lProjHelper.getLProjLanguage(at: path)
                            }
                        }
                    } else {
                        fullContent = try String(contentsOf: url)
                        stringFileName = self.lProjHelper.getLProjLanguage(at: url)
                    }
                    
                    guard let fullContent = fullContent, let stringFileName = stringFileName else {
                        continue
                    }
                    
                    let lines: [String] = fullContent.components(separatedBy: .newlines)
                    
                    DispatchQueue.main.async {
                        self.numberOfLines = lines.count
                    }
                    
                    for line in lines {
                        guard !line.isEmpty else {
                            continue
                        }
                        
                        let pair: [String] = line
                            .replacingOccurrences(of: "\"", with: "", options: .literal)
                            .components(separatedBy: "=")
                        
                        let country: Language? = self.languageWrapper.fetchAvailableLanguages().first(where: {
                            return $0.localeIdentifier == stringFileName
                        })
                        
                        guard let key = pair.object(index: 0), let value = pair.object(index: 1) else {
                            continue
                        }
                        
                        DispatchQueue.main.async {
                            self.progress += 1
                        }
                        
                        let exportableLanguage: ExportableLanguage = .init(
                            key: key,
                            value: value.sanitizedValueIfNeeded,
                            codeLanguage: stringFileName,
                            descriptionLanguage: ("\(Locale(identifier: self.aplicationLocale).localizedString(forLanguageCode: stringFileName) ?? "nullo") - \(country?.description ?? "")")
                        )
                        
                        guard !self.exportableLanguages.contains(where: { $0.key == key && $0.codeLanguage == stringFileName }) else {
                            continue
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
    
    func exportTransalationToStringsFile(url: URL?) {
        guard let url = url else {
            return
        }
        
        Dictionary(grouping: exportableLanguages, by: { $0.codeLanguage }).forEach { language, translations in
            var stringsLine: [String] = []
            
            for translation in translations {
                stringsLine.append("\"\(translation.key)\"= \"\(translation.value)\";")
            }
            
            let content: String = stringsLine.joined(separator: "\n")
            
            lProjHelper.createLProj(
                at: url,
                language: language,
                fileContent: content
            )
        }
    }
    
    func getPreviewStringFile() -> String {
        return ""
    }
    
    func getListOfTranslationsFile() -> [String] {
        Array(exportableGroupedByCode().keys.sorted(by: <))
    }
    
    func getTranslationFromCurrentFile() -> [String: [ExportableLanguage]] {
        guard let transalations: [ExportableLanguage] = exportableGroupedByCode()[currentFile] else {
            return [:]
        }
        
        return [currentFile: transalations]
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
        resetData()
        currentKey = translation.key
        selectedLanguage = translation.codeLanguage
        languagesToEdit.append(translation)
    }
    
    func shouldShowProgressView() -> Bool {
        return progress > 0
    }
}

private extension TranslateViewModel {
    private func exportableGroupedByCode() -> [String: [ExportableLanguage]] {
        return Dictionary(grouping: exportableLanguages) { exportable in
            return exportable.codeLanguage
        }
    }
}
