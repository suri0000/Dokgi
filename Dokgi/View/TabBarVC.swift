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
        tabBar.backgroundColor = .white.withAlphaComponent(0.7)
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        setUpBlur()
        
        // 홈화면 설정
        let homePageVC = HomeViewController()
        homePageVC.tabBarItem = UITabBarItem(title: "홈", image: .tabBarHome, tag: 0)
        
        // 구절화면 설정
        let verseVC = ParagraphViewController()
        verseVC.tabBarItem = UITabBarItem(title: "구절", image: .tabBarParagraph, tag: 1)
        
        // 내 서재 설정
        let myLibraryVC = LibrarySearchViewController()
        myLibraryVC.tabBarItem = UITabBarItem(title: "내 서재", image: .tabBarMyLibrary, tag: 2)
        
        // 탭바 컨트롤러에 뷰 컨트롤러 설정
        let controllers = [homePageVC, verseVC, myLibraryVC]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) } // RootViewController 설정
        
        // 탭 바의 색상 설정
        UITabBar.appearance().tintColor = .charcoalBlue // 선택된 아이템
        UITabBar.appearance().unselectedItemTintColor = .tabBarGray// 선택되지 않은 아이템
        
        // 탭바 상단 경계선
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5))
        lineView.backgroundColor = .tabBarGray
        tabBar.addSubview(lineView)
    }
    
    private func setUpBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = .flexibleWidth
        tabBar.insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
