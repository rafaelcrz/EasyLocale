//
//  ExportableStringSwiftFileView.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 03/07/23.
//

import Foundation
import SwiftUI

struct ExportableStringSwiftFileView: View {
    @State var showingPreview: Bool = false
    @StateObject var viewModel: ExportableStringSwiftFileViewModel = .init()
    
    var exportableLanguages: [ExportableLanguage] = []
    
    var body: some View {
        VStack {
            ScrollView {
                TextEditor(text: $viewModel.previewStringFile)
                    .textSelection(.disabled)
                    .font(.body)
                    .frame(minWidth: 500, minHeight: 500)
            }
            
            GroupBox {
                HStack {
                    Picker("File type", selection: $viewModel.keyFileType) {
                        Text(KeyFileType.struct.rawValue).tag(KeyFileType.struct)
                        Text(KeyFileType.enum.rawValue).tag(KeyFileType.enum)
                    }
                    
                    Picker("Key Type", selection: $viewModel.keyType) {
                        Text(KeyType.string.rawValue).tag(KeyType.string)
                        Text(KeyType.localizedStringKey.rawValue).tag(KeyType.localizedStringKey)
                    }
                    
                    ButtonImage(systemName: .preview, text: "Preview") {
                        viewModel.generateEnumerationStringFile(url: nil)
                    }
                    
                    ButtonImage(systemName: .generate, text: "Generate") {
                        viewModel.generateEnumerationStringFile(url: exportPanel())
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.exportableLanguages = exportableLanguages
        }
    }
    
    private func exportPanel() -> URL? {
        let panel = NSOpenPanel()
        panel.showsHiddenFiles = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.runModal()
        return panel.url
    }
}

struct PreviewExportableView_Previews: PreviewProvider {
    static var previews: some View {
        ExportableStringSwiftFileView()
    }
}
