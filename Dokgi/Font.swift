//
//  Font.swift
//  Dokgi
//
//  Created by 송정훈 on 6/5/24.
//

import UIKit

enum Pretendard: String {
    case bold = "Pretendard-Bold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case semibold = "Pretendard-SemiBold"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
    
    func dynamicFont(size: CGFloat) -> UIFont {
        let customFont = UIFont(name: self.rawValue, size: size)!
        return UIFontMetrics.default.scaledFont(for: customFont)
    }
}
