//
//  ExportableLocaleDetailView.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 30/06/23.
//

import SwiftUI

struct ExportableLocaleDetailView: View {
    let shouldShowProgressView: Bool
    let progress: Double
    let numberOfLines: Int
    var listOfFiles: [String]
    var currentFileTransaltions: [String: [ExportableLanguage]]
    @Binding var currentFile: String
    
    var actionRemove: (ExportableLanguage) -> Void
    var actionEdit: (ExportableLanguage) -> Void
    
    var body: some View {
        VStack {
            // MARK: - Import Progress
            if shouldShowProgressView {
                ProgressView(value: progress, total: Double(numberOfLines))
            }
            
            // MARK: - String File
            Picker("String file", selection: $currentFile) {
                ForEach(listOfFiles, id: \.self) { file in
                    Text(file).tag(file)
                }
            }.pickerStyle(.segmented)
            
            // MARK: - File String Translations
            ExportableLocaleListView(
                exportables: currentFileTransaltions,
                currentFile: currentFile,
                actionRemove: {
                    actionRemove($0)
                }, actionEdit: {
                    actionEdit($0)
                }
            )
        }
    }
}

struct ExportableLocaleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExportableLocaleDetailView(
            shouldShowProgressView: true,
            progress: 0.8,
            numberOfLines: 8,
            listOfFiles: ["pt-BR", "en-US"],
            currentFileTransaltions: ["form.address": [
                ExportableLanguage(
                    key: "form.address",
                    value: "address",
                    codeLanguage: "en-US",
                    descriptionLanguage: "English"
                ),
                ExportableLanguage(
                    key: "form.address",
                    value: "direccion",
                    codeLanguage: "es",
                    descriptionLanguage: "Spanish"
                )
            ]],
            currentFile: .constant("pt-BR"),
            actionRemove: { _ in},
            actionEdit: {_ in }
        )
    }
}
