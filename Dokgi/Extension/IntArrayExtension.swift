//
//  StringExtension.swift
//  Dokgi
//
//  Created by 송정훈 on 6/7/24.
//

import Foundation

extension Array<Int> {
    
    func timeToString() -> String {
        let hour = String(self[0]).count < 2 ? "0\(self[0])" : String(self[0])
        let min = String(self[1]).count < 2 ? "0\(self[1])" : String(self[1])
        let ampm = self[2] == 0 ? "AM" : "PM"
        
        return "\(ampm) \(hour) : \(min)"
    }
    
    func dayToString() -> String {
        let DayArr = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
        
        if self.contains(0) == false || self.contains(1) == false {
            return "매일"
        } else if self.filter({$0 == 0}).count == 1 {
            var str = [String]()
            
            for i in 0...6 {
                if self[i] == 1 {
                    str.append(String(DayArr[i].prefix(1)))
                }
            }
            return str.joined(separator: ",")
        } else if self[1...5].contains(0) == false {
            return "주중"
        } else if self[0] == 1 && self[6] == 1 && self[1...5].contains(1) == false {
            return "주말"
        } else {
            var str = [String]()
            
            for i in 0...6 {
                if self[i] == 1 {
                    str.append(String(DayArr[i].prefix(1)))
                }
            }
            return str.joined(separator: ",")
        }
    }
}
