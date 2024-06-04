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
        
        // 홈화면 설정
        let homePageVC = HomeVC()
        homePageVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)

        // 구절화면 설정
        let verseVC = 구절VC()
        verseVC.tabBarItem = UITabBarItem(title: "구절", image: UIImage(systemName: "doc.plaintext.fill"), tag: 1)

        // 내 서재 설정
        let myLibraryVC = 내서재VC()
        myLibraryVC.tabBarItem = UITabBarItem(title: "내 서재", image: UIImage(systemName: "book"), tag: 2)

        // 탭바 컨트롤러에 뷰 컨트롤러 설정
        viewControllers = [homePageVC, verseVC, myLibraryVC]

        // 탭 바의 색상 설정
        UITabBar.appearance().tintColor = UIColor.black // 선택된 아이템의 색상
        UITabBar.appearance().unselectedItemTintColor = .tabBarGrey// 선택되지 않은 아이템의 색상
    }

}
