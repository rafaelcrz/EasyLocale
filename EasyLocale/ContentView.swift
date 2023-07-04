//
//  ContentView.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 27/06/23.
//
import SwiftUI

struct ContentView: View {
    private let columnWidth: CGFloat = 500
    @State var showingPreview: Bool = false
    @StateObject var viewModel: TranslateViewModel = .init()
    
    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Translation Key
                HStack {
                    Text("Translation key")
                        .fontWeight(.bold)
                    TextField("translation.key", text: $viewModel.currentKey)
                        .textFieldStyle(.roundedBorder)
                }
                
                // MARK: - Append Translations
                ButtonImage(systemName: .update, text: "Update translations") {
                    viewModel.updateStringsFileWithCurrentKeyValue()
                }
            }.padding()
            
            // MARK: - Translation List
            Text("Translations")
                .multilineTextAlignment(.leading)
                .fontWeight(.bold)
            LanguageListView(exportableList: $viewModel.languagesToEdit)
                .navigationSplitViewColumnWidth(min: columnWidth, ideal: columnWidth)
            
            VStack(alignment: .leading) {
                HStack {
                    // MARK: - Available Languages
                    Picker("Languages", selection: $viewModel.selectedLanguage) {
                        ForEach(viewModel.availableLanguages, id:\.localeIdentifier) { language in
                            Text(viewModel.getLocalizedString(forLanguage: language))
                                .tag(language.localeIdentifier)
                        }
                    }
                    
                    // MARK: - New Language
                    ButtonImage(systemName: .plus, text: "Add language") {
                        viewModel.addNewLanguageToTranslation()
                    }
                }
            }.padding()
            
        } detail: {
            VStack(alignment: .leading) {
                ExportableLocaleDetailView(
                    shouldShowProgressView: viewModel.shouldShowProgressView(),
                    progress: viewModel.progress,
                    numberOfLines: viewModel.numberOfLines,
                    listOfFiles: viewModel.getListOfTranslationsFile(),
                    currentFileTransaltions: viewModel.getTranslationFromCurrentFile(),
                    currentFile: $viewModel.currentFile,
                    actionRemove: {
                        viewModel.deleteTransalation($0)
                    }, actionEdit: {
                        viewModel.editTransaction($0)
                    }
                )
                
                HStack {
                    ButtonImage(systemName: .import, text: "Import lproj/strings") {
                        viewModel.importStringLanguage(urls: importPanel())
                    }
                    
                    ButtonImage(systemName: .export, text: "Export .lproj/strings") {
                        viewModel.exportTransalationToStringsFile(url: exportPanel())
                    }
                    
                    ButtonImage(systemName: .generate, text: "Generate swift strings") {
                        showingPreview.toggle()
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: columnWidth, ideal: columnWidth)
            .padding()
        }.sheet(isPresented: $showingPreview) {
            ExportableStringSwiftFileView(exportableLanguages: viewModel.exportableLanguages)
            .toolbar {
                Button("Close", action: {
                    showingPreview = false
                })
            }
        }
    }
}

private extension ContentView {
    func exportPanel() -> URL? {
        let panel = NSOpenPanel()
        panel.showsHiddenFiles = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.runModal()
        return panel.url
    }
    
    func importPanel() -> [URL]? {
        let panel = NSOpenPanel();
        panel.showsHiddenFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [.strings]
        panel.runModal()
        return panel.urls
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
            .previewLayout(.fixed(width: 1010, height: 400))
    }
}
