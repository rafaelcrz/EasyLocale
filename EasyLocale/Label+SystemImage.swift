//
//  Label+SystemImage.swift
//  EasyLocale
//
//  Created by Rafael Ramos on 27/06/23.
//

import Foundation
import SwiftUI

extension Label where Title == Text, Icon == Image {
    init(_ titleKey: LocalizedStringKey, systemImage name: Constants.SystemImage) {
        self.init(titleKey, systemImage: name.rawValue)
    }
}
