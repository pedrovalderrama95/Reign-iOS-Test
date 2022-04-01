//
//  CustomFont.swift
//  ReignTest
//
//  Created by Pedro Valderrama on 30/03/2022.
//

import UIKit

struct CustomFont {
    static func setFontMedium(fontSize: CGFloat) -> UIFont {
        let size = fontSize * (UIScreen.main.bounds.width / 320)
        let font = UIFont.systemFont(ofSize: size, weight: .medium)
        return font
    }
    
}
