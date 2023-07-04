//
//  ExportableLanguage.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 27/06/23.
//

import Foundation

struct ExportableLanguage {
    let id: UUID = UUID()
    var key: String
    var value: String
    let codeLanguage: String
    let descriptionLanguage: String
}
