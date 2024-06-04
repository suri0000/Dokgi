//
//  SettingViewController.swift
//  Dokgi
//
//  Created by 송정훈 on 6/4/24.
//

import UIKit
import SnapKit
import Then

class SettingViewController : UIViewController{
    
    let titleLbl = UILabel().then {
        $0.text = "설정"
        $0.font = UIFont.boldSystemFont(ofSize: 28)
    }
    
    let alarmView = AlarmView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(titleLbl)
        view.addSubview(alarmView)
        
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        alarmView.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

#Preview{SettingViewController()}
