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
        view.backgroundColor = .white
        
        // 홈화면 설정
//        let homePageVC = HomeViewController()
        let homePageVC = UINavigationController(rootViewController: HomeViewController())
        homePageVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarHome"), tag: 0)

        // 구절화면 설정
//        let verseVC = ParagraphViewController()
//        verseVC.tabBarItem = UITabBarItem(title: "구절", image: UIImage(systemName: "doc.plaintext.fill"), tag: 1)

        // 내 서재 설정
        let myLibraryVC = LibrarySearchViewController()
        myLibraryVC.tabBarItem = UITabBarItem(title: "내 서재", image: UIImage(systemName: "book"), tag: 2)

        // 탭바 컨트롤러에 뷰 컨트롤러 설정
        viewControllers = [homePageVC, myLibraryVC]

        // 탭 바의 색상 설정
        UITabBar.appearance().tintColor = UIColor.black // 선택된 아이템
        UITabBar.appearance().unselectedItemTintColor = .tabBarGray// 선택되지 않은 아이템
        
        // 탭바 상단 경계선
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        lineView.backgroundColor = .tabBarGray
        tabBar.addSubview(lineView)
        
        tabBar.barTintColor = UIColor.red
        
        configureNavigationBar(homePageVC)
    }
    
    // 홈 상단에 설정 페이지 이동
    private func configureNavigationBar(_ navigationController: UINavigationController) {
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(didTapSetting))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func didTapSetting() {
        let settingVC = SettingViewController()
//        settingVC.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(settingVC, animated: true)
//        present(settingVC, animated: true)
        let navController = UINavigationController(rootViewController: settingVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }

}
