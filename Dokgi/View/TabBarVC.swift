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
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 10)
        
        var config = UIButton.Configuration.plain()
        button.configuration = config
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.alpha = 0.75
        
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
        
        // 홈화면 설정
        let homePageVC = HomeViewController()
        homePageVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarHome"), tag: 0)
        let homeNaviVC = UINavigationController(rootViewController: homePageVC)
        homeNaviVC.navigationBar.isHidden = true

        // 구절화면 설정
        let verseVC = ParagraphViewController()
        verseVC.tabBarItem = UITabBarItem(title: "구절", image: UIImage(named: "tabBarParagraph"), tag: 1)

        // 내 서재 설정
        let myLibraryVC = LibrarySearchViewController()
        myLibraryVC.tabBarItem = UITabBarItem(title: "내 서재", image: UIImage(named: "tabBarMyLibrary"), tag: 2)

        // 탭바 컨트롤러에 뷰 컨트롤러 설정
        let controllers = [homeNaviVC, verseVC, myLibraryVC]
        setViewControllers(controllers, animated: true)

        // 탭 바의 색상 설정
        UITabBar.appearance().tintColor = UIColor.charcoalBlue // 선택된 아이템
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
        print("구절추가 버튼 클릭")
        let navController = UINavigationController(rootViewController: addVC)
        self.navigationController?.pushViewController(navController, animated: true)
    }
}
