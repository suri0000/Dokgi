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
    
    let hourArr = [Int](1...12)
    let minArr = [Int](0...59)
    let ampmArr = ["AM", "PM"]
    let DayArr = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    static var remindTime = BehaviorRelay<[Int]>(value: [3 , 00, 1])
    static var writeTime = BehaviorRelay<[Int]>(value: [3 , 00, 1])
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
}
