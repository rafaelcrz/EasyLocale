//
//  ExportableLanguage.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 27/06/23.
//

import Foundation

//    "poi.closed.unsure": "Não tenho certeza",
struct ExportableLanguage {
    let id: UUID = UUID()
    let key: String
    var value: String
    let codeLanguage: String
    let descriptionLanguage: String
}
