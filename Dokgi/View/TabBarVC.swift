//
//  TabBarVC.swift
//  Dokgi
//
//  Created by 한철희 on 6/4/24.
//

import UIKit

class TabBarVC: UITabBarController {
    
    private let floatButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 35
        button.backgroundColor = .charcoalBlue
        button.setImage(.plus, for: .normal)
        button.tintColor = .white
        
        var config = UIButton.Configuration.plain()
        button.configuration = config
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
        
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
        setViewControllers(controllers, animated: true)

        // 탭 바의 색상 설정
        UITabBar.appearance().tintColor = .charcoalBlue // 선택된 아이템
        UITabBar.appearance().unselectedItemTintColor = .tabBarGray// 선택되지 않은 아이템
        
        // 탭바 상단 경계선
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5))
        lineView.backgroundColor = .tabBarGray
        tabBar.addSubview(lineView)
        
        tabBar.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatButton.frame = CGRect(
            x: view.frame.size.width - 95,
            y: view.frame.size.height - 122 - 70,
            width: 70,
            height: 70
        )
    }
    
    @objc func didTabButton() {
        let addVC = AddVerseVC()
        addVC.modalPresentationStyle = .fullScreen
        present(addVC, animated: true)
    }
}
