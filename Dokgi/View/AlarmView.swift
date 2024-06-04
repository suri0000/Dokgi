//
//  AlarmView.swift
//  Dokgi
//
//  Created by 송정훈 on 6/4/24.
//

import UIKit
import SnapKit

class AlarmView : UIView {
    
    let alarmTitle = UILabel().then {
        $0.text = "알림 설정"
        $0.font = Pretendard.bold.of(size: 20)
    }
    
    let remindSwitch = UISwitch().then {
        $0.isOn = true
    }
    
    let remindTitle = UILabel().then {
        $0.text = "리마인드 알림"
        $0.font = Pretendard.regular.of(size: 17)
    }
    
    let remindDescription = UILabel().then {
        $0.text = "구절을 리마인드 해주는 알림"
        $0.textColor = UIColor(named: "AlarmMemoGray")
        $0.font = Pretendard.regular.of(size: 14)
    }
    
    let remindStack = UIStackView().then {
        $0.spacing = 5
        $0.axis = .vertical
    }
    
    let remindTimeLbl = UILabel().then {
        $0.text = "알림 시간"
        $0.font = Pretendard.regular.of(size: 14)
        $0.textColor = UIColor(named: "AlarmSettingText")
    }
    
    let remindTimeBtn = UIButton().then {
        $0.setTitle("PM 15 : 00", for: .normal)
        $0.setTitleColor(UIColor(named: "AlarmSettingText"), for: .normal)
        $0.titleLabel?.font = Pretendard.regular.of(size: 14)
    }
    
    let border = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.8431372549, blue: 0.8431372549, alpha: 1)
    }
    
    let remindTimeStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 100
    }
    
    let writeSwitch = UISwitch().then {
        $0.isOn = true
    }
    
    let writeTitle = UILabel().then {
        $0.text = "기록하기 알림"
        $0.font = Pretendard.regular.of(size: 17)
    }
    
    let writeDescription = UILabel().then {
        $0.text = "독서 알림"
        $0.textColor = UIColor(named: "AlarmMemoGray")
        $0.font = Pretendard.regular.of(size: 14)
    }
    
    let writeStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    let writeWeek = UILabel().then {
        $0.text = "알림 요일"
        $0.font = Pretendard.regular.of(size: 14)
        $0.textColor = UIColor(named: "AlarmSettingText")
    }
    
    let weekBtn = UIButton().then {
        $0.setTitle("매일", for: .normal)
        $0.setTitleColor(UIColor(named: "AlarmSettingText"), for: .normal)
        $0.titleLabel?.font = Pretendard.regular.of(size: 14)
    }
    
    let writeWeekStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    let writeTimeLbl = UILabel().then {
        $0.text = "알림 시간"
        $0.font = Pretendard.regular.of(size: 14)
        $0.textColor = UIColor(named: "AlarmSettingText")
    }
    
    let writeTimeBtn = UIButton().then {
        $0.setTitle("PM 15 : 00", for: .normal)
        $0.setTitleColor(UIColor(named: "AlarmSettingText"), for: .normal)
        $0.titleLabel?.font = Pretendard.regular.of(size: 14)
    }
    
    let writeTimeStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        [remindTitle, remindDescription].forEach {
            remindStack.addArrangedSubview($0)
        }
        
        [remindTimeLbl, remindTimeBtn].forEach {
            remindTimeStack.addArrangedSubview($0)
        }
        
        [writeTitle, writeDescription].forEach {
            writeStack.addArrangedSubview($0)
        }
        
        [writeWeek, weekBtn].forEach {
            writeWeekStack.addArrangedSubview($0)
        }
        
        [writeTimeLbl, writeTimeBtn].forEach {
            writeTimeStack.addArrangedSubview($0)
        }
        addSubview(alarmTitle)
        addSubview(remindSwitch)
        addSubview(remindStack)
        addSubview(remindTimeStack)
        addSubview(border)
        addSubview(writeSwitch)
        addSubview(writeStack)
        addSubview(writeWeekStack)
        addSubview(writeTimeStack)
        
        alarmTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(27)
            
        }
        remindStack.snp.makeConstraints {
            $0.top.equalTo(alarmTitle.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(27)
        }
        
        remindSwitch.snp.makeConstraints {
            $0.centerY.equalTo(remindStack)
            $0.trailing.equalToSuperview().inset(27)
        }
        
        remindTimeStack.snp.makeConstraints {
            $0.top.equalTo(remindStack.snp.bottom).offset(23)
            $0.leading.trailing.equalToSuperview().inset(27)
        }
        
        border.snp.makeConstraints {
            $0.top.equalTo(remindTimeStack.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(27)
            $0.height.equalTo(1)
        }
        
        writeStack.snp.makeConstraints {
            $0.top.equalTo(border.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(27)
        }
        
        writeSwitch.snp.makeConstraints {
            $0.centerY.equalTo(writeStack)
            $0.trailing.equalToSuperview().inset(27)
        }
        
        writeWeekStack.snp.makeConstraints {
            $0.top.equalTo(writeStack.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(27)
        }
        
        writeTimeStack.snp.makeConstraints {
            $0.top.equalTo(writeWeekStack.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(27)
        }
    }
}
