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
import NotificationCenter

class SettingViewController : UIViewController{
    let disposeBag = DisposeBag()
    
    let viewModel = DayTimeViewModel()
    
    var myUserDefaults = UserDefaults.standard
    
    let titleLbl = UILabel().then {
        $0.text = "설정"
        $0.font = Pretendard.bold.of(size: 28)
    }
    
    let alarmView = AlarmView()
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        buttonTap()
        buttonTitle()
        switchOnOff()
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
               for request in requests {
                   print("Identifier: \(request.identifier)")
                   print("Title: \(request.content.title)")
                   print("Body: \(request.content.body)")
                   print("Trigger: \(String(describing: request.trigger))")
                   print("---")
               }
           }
    }
    
    // MARK: - Layout
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
        alarmView.remindSwitch.isOn = myUserDefaults.bool(forKey: "remindSwitch")
        alarmView.writeSwitch.isOn = myUserDefaults.bool(forKey: "writeSwitch")
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
            self?.myUserDefaults.set(Time, forKey: "remindTime")
            self?.viewModel.sendLocalPushRemind(identifier: "remindTime", time: Time)
        }.disposed(by: disposeBag)
        
        DayTimeViewModel.writeTime.subscribe {[weak self] Time in
            self?.alarmView.writeTimeBtn.setTitle(self?.viewModel.timeToString(time: Time), for: .normal)
            self?.myUserDefaults.set(Time, forKey: "writeTime")
            self?.viewModel.sendLocalPushWrite(identifier: "writeTime", time: Time, day: DayTimeViewModel.dayCheck.value)
        }.disposed(by: disposeBag)
        
        DayTimeViewModel.dayCheck.subscribe {[weak self] week in
            self?.alarmView.weekBtn.setTitle(self?.viewModel.dayToString(day: week), for: .normal)
            self?.myUserDefaults.set(week, forKey: "writeWeek")
            self?.viewModel.sendLocalPushWrite(identifier: "writeTime", time: DayTimeViewModel.writeTime.value, day: week)
        }.disposed(by: disposeBag)
    }
    
    func switchOnOff() {
        alarmView.remindSwitch.rx.isOn.subscribe { [weak self] bool in
            self?.viewModel.removePendingNotification(identifiers: "remindTime",time: DayTimeViewModel.remindTime.value, on: bool)
            self?.myUserDefaults.set(bool, forKey: "remindSwitch")
        }.disposed(by: disposeBag)
        
        alarmView.writeSwitch.rx.isOn.subscribe { [weak self] bool in
            self?.viewModel.removePendingNotification(identifiers: "writeTime",time: DayTimeViewModel.remindTime.value, on: bool)
            self?.myUserDefaults.set(bool, forKey: "writeSwitch")
        }.disposed(by: disposeBag)
    }
}
