//
//  DayTimeViewModel.swift
//  Dokgi
//
//  Created by 송정훈 on 6/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class DayTimeViewModel {
    
    static var dayCheck = BehaviorRelay<[Int]>(value: Array(repeating: 1, count: 7))
    static var remindTime = BehaviorRelay<[Int]>(value: [3 , 00, 1])
    static var writeTime = BehaviorRelay<[Int]>(value: [3 , 00, 1])
    
    let hourArr = [Int](1...12)
    let minArr = [Int](0...59)
    let ampmArr = ["AM", "PM"]
    let DayArr = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
    var selectday = [Int](1 ... 7)
    var selectTime : [Int] = [3 , 00 , 1]
    
    func setTime(row : Int , component : Int) {
        switch component {
        case 0 :
            selectTime[0] = hourArr[row % hourArr.count]
        case 1 :
            selectTime[1] = minArr[row % minArr.count]
        case 2:
            selectTime[2] = row % ampmArr.count
        default:
            print(0)
        }
    }
    
    func saveTime(write : Bool) {
        if write == true {
            DayTimeViewModel.writeTime.accept(selectTime)
        }else {
            DayTimeViewModel.remindTime.accept(selectTime)
        }
    }
    
    func timeToString(time : [Int]) -> String {
        let hour = String(time[0]).count < 2 ? "0\(time[0])" : String(time[0])
        let min = String(time[1]).count < 2 ? "0\(time[1])" : String(time[1])
        let ampm = time[2] == 0 ? "AM" : "PM"
        
        return "\(ampm) \(hour) : \(min)"
    }
    
    func dayimage(row : Int) {
        if self.selectday[row] != 0 {
            self.selectday[row] = 0
        }else {
            self.selectday[row] = 1
        }
    }
    
    func dayToString() -> String{
        if DayTimeViewModel.dayCheck.value.contains(0) == false {
            return "매일"
        }else if DayTimeViewModel.dayCheck.value.filter({$0 == 0}).count == 1{
            var str = [String]()
            
            for i in 0 ... 6 {
                if DayTimeViewModel.dayCheck.value[i] == 1 {
                    str.append(String(self.DayArr[i].prefix(1)))
                }
            }
            return str.joined(separator: ",")
        }else if DayTimeViewModel.dayCheck.value[1...5].contains(0) == false {
            return "주중"
        }else if DayTimeViewModel.dayCheck.value[0] == 1 && DayTimeViewModel.dayCheck.value[6] == 1 && DayTimeViewModel.dayCheck.value[1...5].contains(1) == false {
            return "주말"
        }else {
            var str = [String]()
            
            for i in 0 ... 6 {
                if DayTimeViewModel.dayCheck.value[i] == 1 {
                    str.append(String(self.DayArr[i].prefix(1)))
                }
            }
            return str.joined(separator: ",").count == 0 ? "노 알림?" : str.joined(separator: ",")
        }
    }
}
