//
//  ContentView.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 27/06/23.
//
import SwiftUI

struct ContentView: View {
    @State var showingAddKeyDialog: Bool = false
    
    @StateObject var viewModel: TranslateViewModel = .init()
    
    var body: some View {
        NavigationSplitView {
            Text("Language key")
            TextField("string key", text: $viewModel.currentKey)
                .textFieldStyle(.roundedBorder)
                .padding()
            LanguageListView(exportableList: $viewModel.languagesToExport)
                .navigationSplitViewColumnWidth(400)
            
            VStack(alignment: .leading) {
                HStack {
                    Picker("Locales", selection: $viewModel.selectedLanguage) {
                        ForEach(viewModel.availableLanguages, id:\.localeIdentifier) { language in
                            Text(viewModel.getLocalizedString(forLanguage: language))
                                .tag(language.localeIdentifier)
                        }
                    }
                    Button {
                        viewModel.addNewLanguage()
                    } label: {
                        Label("Add location", systemImage: .plus)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                
                Button {
                    showingAddKeyDialog.toggle()
                    viewModel.addKeyStringToStringsFile()
                } label: {
                    Text("Add (\(viewModel.currentKey)) key to strings file")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }.padding()
            
        } detail: {
            VStack {
                ExportableLocaleListView(exportables: viewModel.exportableGroupedByKey())
                
                HStack {
                    Button {
                        viewModel.exportStringLanguage()
                    } label: {
                        Label("Preview .strings", systemImage: "pc")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    Button {
                        viewModel.exportStringLanguage()
                    } label: {
                        Label("Export .strings", systemImage: .export)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                
                Button {
                    
                } label: {
                    Label("Location to export", systemImage: .folder)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .navigationSplitViewColumnWidth(min: 500, ideal: 500)
            .padding()
        }.alert(viewModel.currentKey, isPresented: $showingAddKeyDialog) {
            Button("OK") {}
            Button("cancel") { showingAddKeyDialog = false }
        } message: {
            Text("Add \(viewModel.currentKey) to the pt-Br.lproj file\n\nTo add more languages click on \"Add location\" button ")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
            .previewLayout(.fixed(width: 950, height: 400))
    }
}
