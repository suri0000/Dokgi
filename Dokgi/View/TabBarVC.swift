//
//  TabBarVC.swift
//  Dokgi
//
//  Created by 한철희 on 6/4/24.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AlarmPageVC 설정
        let alarmPageVC = AlarmPageVC()
        let alarmPageNav = UINavigationController(rootViewController: alarmPageVC)
        alarmPageNav.tabBarItem.title = "알람"
        alarmPageNav.tabBarItem.image = UIImage(systemName: "alarm")

        // StopWatchViewController 설정
        let stopWatchVC = StopWatchViewController()
        let stopWatchNav = UINavigationController(rootViewController: stopWatchVC)
        stopWatchNav.tabBarItem.title = "스톱워치"
        stopWatchNav.tabBarItem.image = UIImage(systemName: "stopwatch")
        
        // TimerViewController 설정
        let timerVC = TimerViewController()
        let timerNav = UINavigationController(rootViewController: timerVC)
        timerNav.tabBarItem.title = "타이머"
        timerNav.tabBarItem.image = UIImage(systemName: "timer")

        // 탭바 컨트롤러에 뷰 컨트롤러 설정
        viewControllers = [alarmPageNav, stopWatchNav, timerNav]
        
        // 탭 바의 색상 설정
        UITabBar.appearance().tintColor = ColorPalette.wakeRed // 선택된 아이템의 색상
        UITabBar.appearance().unselectedItemTintColor = UIColor.black // 선택되지 않은 아이템의 색상
        
        UITabBar.appearance().backgroundColor = ColorPalette.wakeBeige // 여기서 원하는 색상으로 설정
    }

}
