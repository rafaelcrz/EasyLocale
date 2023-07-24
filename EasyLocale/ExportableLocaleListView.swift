//
//  ExportableLocaleListView.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 28/06/23.
//

import Foundation
import SwiftUI

struct ExportableLocaleListView: View {
    
    var exportables: [String: [ExportableLanguage]] = [:]
    var currentFile: String
    var actionRemove: (ExportableLanguage) -> Void
    var actionEdit: (ExportableLanguage) -> Void
    
    @State private var search: String = ""
    
    private var searchKeyResults: [String: [ExportableLanguage]] {
        if search.isEmpty {
            return exportables
        } else {
            return [
                currentFile: exportables[currentFile]?.filter({ language in
                    return language.key.lowercased().contains(search.lowercased())
                }) ?? []
            ]
        }
    }
    
    var body: some View {
        List {
            ForEach(Array(exportables.keys).sorted(by: { $0 < $1 }), id: \.self) { key in
                Section {
                    ForEach(searchKeyResults[key] ?? [], id:\.key) { exportable in
                        HStack {
                            Image(systemName: "network")
                            VStack(alignment: .leading, spacing: 4) {
                                Text("String key: \(exportable.key)")
                                    .fontWeight(.bold)
                                Text("String value: \(exportable.value)")
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            ButtonImage(systemName: .trash, foregroundColor: .red, action: {
                                actionRemove(exportable)
                            })
                            ButtonImage(systemName: .edit, action: {
                                actionEdit(exportable)
                            })

                        }.padding()
                    }
                } header: {
                    Text("Total keys: \(searchKeyResults[key]?.count ?? 0)")
                }.headerProminence(Prominence.increased)
            }
        }
        .searchable(text: $search)
        .listStyle(.inset(alternatesRowBackgrounds: true))
    }
}

struct ExportableLocaleListView_Previews: PreviewProvider {
    static var previews: some View {
        ExportableLocaleListView(exportables: [
            "form.address": [
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
            ],
            "form.name": [
                ExportableLanguage(
                    key: "form.address",
                    value: "address",
                    codeLanguage: "en-US",
                    descriptionLanguage: "English"
                )
            ]
        ], currentFile: "pt_Br", actionRemove: {_ in }, actionEdit: {_ in})
    }
}
