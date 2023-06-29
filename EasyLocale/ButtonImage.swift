//
//  ButtonImage.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 29/06/23.
//

import Foundation
import SwiftUI

struct ButtonImage: View {
    let systemName: String
    var text: String?
    var foregroundColor: Color = Color(.labelColor)
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if let text = text {
                    Text(text)
                }
                Image(systemName: systemName)
                    .foregroundColor(foregroundColor)
                    .padding(4)
            }
        }
    }
}

struct ButtonImage_Previews: PreviewProvider {
    static var previews: some View {
        ButtonImage(systemName: "trash", action: {})
    }
}
