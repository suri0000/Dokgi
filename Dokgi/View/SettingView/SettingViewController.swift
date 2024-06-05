//
//  SettingViewController.swift
//  Dokgi
//
//  Created by 송정훈 on 6/4/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SettingViewController : UIViewController{
    let disposeBag = DisposeBag()
    
    let viewModel = DayTimeViewModel()
    
    let titleLbl = UILabel().then {
        $0.text = "설정"
        $0.font = Pretendard.bold.of(size: 28)
    }
    
    let alarmView = AlarmView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        buttonTap()
        buttonTitle()
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
    
    func buttonTap() {
        alarmView.remindTimeBtn.rx.tap.subscribe { _ in
            
            self.present(TimePickerViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        alarmView.weekBtn.rx.tap.subscribe { _ in
            
            self.present(DaySelectViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        alarmView.writeTimeBtn.rx.tap.subscribe { _ in
            
            self.present(writeTimeViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    func buttonTitle() {
        DayTimeViewModel.remindTime.subscribe {[weak self] Time in
            self?.alarmView.remindTimeBtn.setTitle(self?.viewModel.timeToString(time: Time), for: .normal)
        }.disposed(by: disposeBag)
        
        DayTimeViewModel.writeTime.subscribe {[weak self] Time in
            self?.alarmView.writeTimeBtn.setTitle(self?.viewModel.timeToString(time: Time), for: .normal)
        }.disposed(by: disposeBag)
    }
}
//
//#Preview{SettingViewController()}
