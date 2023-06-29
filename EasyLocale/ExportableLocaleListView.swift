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
    var actionRemove: (ExportableLanguage) -> Void
    var actionEdit: (ExportableLanguage) -> Void
    
    @State private var search: String = ""
    
    private var keySections: [String] {
        Array(exportables.keys).sorted(by: { $0 < $1 })
    }
    
    private var searchKeyResults: [String] {
        if search.isEmpty {
            return keySections
        } else {
            return keySections.filter { $0.contains(search) }
        }
    }
    
    var body: some View {
        List {
            ForEach(searchKeyResults, id: \.self) { key in
                ForEach(exportables[key] ?? [], id:\.id) { exportable in
                    HStack {
                        Image(systemName: "network")
                        VStack(alignment: .leading, spacing: 4) {
                            Text("String key: \(exportable.key)")
                                .fontWeight(.bold)
                            Text("String value: \(exportable.value)")
                                .fontWeight(.bold)
                        }
                        Spacer()
                        ButtonImage(systemName: "trash", foregroundColor: .red, action: {
                            actionRemove(exportable)
                        })
                        ButtonImage(systemName: "pencil", action: {
                            actionEdit(exportable)
                        })

                    }.padding()
                }
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
        ], actionRemove: {_ in }, actionEdit: {_ in})
    }
}
