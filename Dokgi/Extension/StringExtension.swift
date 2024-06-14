//
//  StringExtension.swift
//  Dokgi
//
//  Created by 송정훈 on 6/14/24.
//

import Foundation

extension String {
    func toDate() -> Date {
       let formatter = DateFormatter()
    
       formatter.dateFormat = "yyyy. MM. dd"
       formatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        
        return formatter.date(from: self) ?? Date()
    }
}
