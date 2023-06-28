//
//  LanguageListView.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 27/06/23.
//

import SwiftUI

struct LanguageListView: View {
    @Binding var exportableList: [ExportableLanguage]
    
    var body: some View {
        List {
            ForEach($exportableList, id:\.id) { $input in
                VStack(alignment: .leading) {
                    Text("\(input.descriptionLanguage) (\(input.codeLanguage))")
                    HStack {
                        TextField("string locale", text: $input.value)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            removeLanguage(byCode: input.codeLanguage)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                }
            }
            
        }
    }
    
    private func removeLanguage(byCode: String) {
        exportableList = exportableList.filter { $0.codeLanguage != byCode }
    }
}

struct LanguageListView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageListView(
            exportableList: .constant([ExportableLanguage(
                key: "Name",
                value: "Nome",
                codeLanguage: "pt-BR",
                descriptionLanguage: "Brazil"
            )])
        )
    }
}
