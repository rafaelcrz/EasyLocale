//
//  FileManagerHelper.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 30/06/23.
//

import Foundation

protocol FileHelper {
    func createDirectory(at path: URL)
    func createFile(at path: URL, with content: String, `extension`: String)
}

final class FileManagerHelper: FileHelper {
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
