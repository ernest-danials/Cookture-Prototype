//
//  String+Ext.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-07.
//

import SwiftUI

extension String {
    var capitalisedFirst: String {
        guard !isEmpty else { return "" }
        
        let capitalisedFirstLetter = self.first!.uppercased()
        
        return capitalisedFirstLetter + String(self.dropFirst())
    }
}
