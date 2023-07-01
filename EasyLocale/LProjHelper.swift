//
//  LProjHelper.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 30/06/23.
//

import Foundation

protocol LProjHelperProtocol {
    func createLProj(at path: URL, language: String, fileContent content: String)
    func getLProjLanguage(at path: URL) -> String?
}

final class LProjHelper: LProjHelperProtocol {
    func createLProj(at path: URL, language: String, fileContent content: String) {
        let folderPath: URL = path.appendingPathComponent("\(language).lproj")
        createDirectory(at: folderPath)
        createFile(at: folderPath, with: content, extension: "Localizable.strings")
    }
    
    func getLProjLanguage(at path: URL) -> String? {
        let lprojPath: String? = path.pathComponents.first(where: { $0.contains(".lproj") })
        let stringsPath: String? = path.pathComponents.first(where: { $0.contains(".strings") })
        return (lprojPath as? NSString)?.deletingPathExtension ?? (stringsPath as? NSString)?.deletingPathExtension
    }
}

private extension LProjHelper {
    func createDirectory(at path: URL) {
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func createFile(at path: URL, with content: String, `extension`: String) {
        do {
            let filePath: URL = path.appendingPathComponent(`extension`)
            try content.write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
