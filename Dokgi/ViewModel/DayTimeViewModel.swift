//
//  DayTimeViewModel.swift
//  Dokgi
//
//  Created by 송정훈 on 6/5/24.
//

import Foundation
import RxSwift
import RxCocoa
import NotificationCenter

class DayTimeViewModel {
    
    static var dayCheck = BehaviorRelay<[Int]>(value: UserDefaults.standard.array(forKey: "writeWeek") as? [Int] ?? [1, 1, 1, 1, 1, 1, 1])
    static var remindTime = BehaviorRelay<[Int]>(value: UserDefaults.standard.array(forKey: "remindTime") as? [Int] ?? [3 , 00, 1])
    static var writeTime = BehaviorRelay<[Int]>(value: UserDefaults.standard.array(forKey: "writeTime") as? [Int] ?? [3 , 00, 1])
    
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
    
    func dayToString(day : [Int]) -> String{
        if day.contains(0) == false {
            return "매일"
        }else if day.filter({$0 == 0}).count == 1{
            var str = [String]()
            
            for i in 0 ... 6 {
                if day[i] == 1 {
                    str.append(String(self.DayArr[i].prefix(1)))
                }
            }
            return str.joined(separator: ",")
        }else if day[1...5].contains(0) == false {
            return "주중"
        }else if day[0] == 1 && day[6] == 1 && day[1...5].contains(1) == false {
            return "주말"
        }else {
            var str = [String]()
            
            for i in 0 ... 6 {
                if day[i] == 1 {
                    str.append(String(self.DayArr[i].prefix(1)))
                }
            }
            return str.joined(separator: ",").count == 0 ? "노 알림?" : str.joined(separator: ",")
        }
    }
    
    func sendLocalPushRemind(identifier : String, time : [Int]) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "오늘 독서 어때요?", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "독서를 하고 마음에 드는 구절을 기록해봐요!", arguments: nil)
        content.sound = UNNotificationSound.default
        
        var dateInfo = DateComponents()
        dateInfo.calendar = Calendar.current
        dateInfo.hour = time[2] == 1 ? time[0] + 12 : time[0]
        dateInfo.minute = time[1]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error) in
            if let error = error {
                print(error)
            }else {
                print("send")
            }
            
        }
    }
    
    func sendLocalPushWrite(identifier : String, time : [Int], day : [Int]) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "오늘 독서 어때요?", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "독서를 하고 마음에 드는 구절을 기록해봐요!", arguments: nil)
        content.sound = UNNotificationSound.default
        
        for i in 0 ... 6 {
            if day[i] == 0 {
                continue
            }
            var dateInfo = DateComponents()
            dateInfo.calendar = Calendar.current
            dateInfo.hour = time[2] == 1 ? time[0] + 12 : time[0]
            dateInfo.minute = time[1]
            dateInfo.weekday = i + 1
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            let request = UNNotificationRequest(identifier: "\(identifier)_\(i)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            
            center.add(request) { (error) in
                if let error = error {
                    print(error)
                }else {
                    print("send")
                }
                
            }
        }
    }
    
    func removePendingNotification(identifiers: String, time : [Int], on : Bool ){
        if on == true {
            if identifiers == "remindTime" {
                self.sendLocalPushRemind(identifier: identifiers, time: time)
            }else {
                self.sendLocalPushWrite(identifier: identifiers, time: time, day: DayTimeViewModel.dayCheck.value)
            }
        }else {
            if identifiers == "remindTime" {
                UNUserNotificationCenter
                    .current()
                    .removePendingNotificationRequests(withIdentifiers: [identifiers])
            }else {
                for i in 0 ... 6 {
                    if DayTimeViewModel.dayCheck.value[i] == 1 {
                        UNUserNotificationCenter
                            .current()
                            .removePendingNotificationRequests(withIdentifiers: ["\(identifiers)_\(i)"])
                    }
                }
            }
        }
    }
}
