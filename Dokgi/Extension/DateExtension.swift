//
//  DateExtension.swift
//  Dokgi
//
//  Created by 송정훈 on 6/14/24.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy. MM. dd"
        
        return formatter.string(from: self)
    }
}
