//
//  ButtonImage.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 29/06/23.
//

import Foundation
import SwiftUI

struct ButtonImage: View {
    let systemName: Constants.SystemImage
    var text: String?
    var foregroundColor: Color = Color(.labelColor)
    var controlSize: ControlSize = .regular
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: systemName.rawValue)
                    .foregroundColor(foregroundColor)
                    .padding(4)
                if let text = text {
                    Text(text)
                }
            }
        }.controlSize(controlSize)
    }
}

struct ButtonImage_Previews: PreviewProvider {
    static var previews: some View {
        ButtonImage(systemName: .trash, action: {})
    }
}
