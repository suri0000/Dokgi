//
//  SettingViewController.swift
//  Dokgi
//
//  Created by 송정훈 on 6/4/24.
//

import NotificationCenter
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SettingViewController: UIViewController{
    let disposeBag = DisposeBag()
    let alarmView = AlarmView()
    let viewModel = DayTimeViewModel()
    let titleLbl = UILabel().then {
        $0.text = "설정"
        $0.font = Pretendard.bold.dynamicFont(style: .title2)
    }
    
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
        alarmView.remindSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.remindSwitch.rawValue)
        alarmView.writeSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.writeSwitch.rawValue)
    }
    
    func buttonTap() {
        alarmView.remindTimeBtn.rx.tap.subscribe { _ in
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.remindSwitch.rawValue) == true {
                let remindVC = TimePickerViewController()
                remindVC.writeBool = false
                self.present(remindVC, animated: true)
            }
        }.disposed(by: disposeBag)
        
        alarmView.weekBtn.rx.tap.subscribe { _ in
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.writeSwitch.rawValue) == true {
                self.present(DaySelectViewController(), animated: true)
            }
            
        }.disposed(by: disposeBag)
        
        alarmView.writeTimeBtn.rx.tap.subscribe { _ in
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.writeSwitch.rawValue) == true {
                let writeVC = TimePickerViewController()
                writeVC.writeBool = true
                self.present(writeVC, animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
    func buttonTitle() {
        DayTimeViewModel.remindTime.subscribe(with: self) { (self, Time) in
            self.updateButtonTitleAndSendNotification(button: self.alarmView.remindTimeBtn, title: Time.timeToString(), switchControl: self.alarmView.remindSwitch.isOn, identifier: "remindTime", time: Time, day: [])
        }.disposed(by: disposeBag)
        
        DayTimeViewModel.writeTime.subscribe(with: self) { (self, Time) in
            self.updateButtonTitleAndSendNotification(button: self.alarmView.writeTimeBtn, title: Time.timeToString(), switchControl: self.alarmView.writeSwitch.isOn, identifier: "writeTime", time: Time, day: DayTimeViewModel.dayCheck.value)
        }.disposed(by: disposeBag)
        
        DayTimeViewModel.dayCheck.subscribe(with: self) { (self, week) in
            self.alarmView.writeSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.writeSwitch.rawValue)
            self.updateButtonTitleAndSendNotification(button: self.alarmView.weekBtn, title: DayTimeViewModel.dayCheck.value.dayToString(), switchControl: self.alarmView.writeSwitch.isOn, identifier: "writeTime", time: DayTimeViewModel.writeTime.value, day: week)
        }.disposed(by: disposeBag)
    }
    
    func switchOnOff() {
        alarmView.remindSwitch.rx.isOn.subscribe(with: self) { (self, bool) in
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.notification.rawValue) == true {
                self.viewModel.removePendingNotification(identifiers: "remindTime", time: DayTimeViewModel.remindTime.value, on: bool)
            }
        }.disposed(by: disposeBag)
        
        alarmView.writeSwitch.rx.isOn.subscribe(with: self) { (self, bool) in
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.notification.rawValue) == true {
                self.viewModel.removePendingNotification(identifiers: "writeTime", time: DayTimeViewModel.remindTime.value, on: bool)
            }
        }.disposed(by: disposeBag)
    }
    
    private func updateButtonTitleAndSendNotification(button: UIButton, title: String, switchControl: Bool, identifier: String, time: [Int], day: [Int]) {
        button.setTitle(title, for: .normal)
        if switchControl == true {
            if identifier == "remindTime" {
                viewModel.sendLocalPushRemind(identifier: identifier, time: time)
            } else if identifier == "writeTime" {
                viewModel.sendLocalPushWrite(identifier: identifier, time: time, day: day)
            }
        }
    }
}
