//
//  DaySelectViewController.swift
//  Dokgi
//
//  Created by 송정훈 on 6/5/24.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class DaySelectViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private let viewModel = DayTimeViewModel()
    
    let cancelBtn = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.brightRed, for: .normal)
        $0.titleLabel?.font = Pretendard.regular.dynamicFont(style: .body)
    }
    
    let titleLbl = UILabel().then {
        $0.text = "알림 요일 설정"
        $0.font = Pretendard.semibold.dynamicFont(style: .title3)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    let saveBtn = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.skyBlue, for: .normal)
        $0.titleLabel?.font = Pretendard.regular.dynamicFont(style: .body)
    }
    
    let titleStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
    }
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.selectday = DayTimeViewModel.dayCheck.value
        view.backgroundColor = .white
        let smallId = UISheetPresentationController.Detent.Identifier("small")
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: smallId) { context in
            return UIScreen.main.bounds.size.height - 450
        }
        if let sheet = sheetPresentationController {
            sheet.detents = [smallDetent]
            sheet.largestUndimmedDetentIdentifier = smallId
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 8
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: DayTableViewCell.identifier)
        setupLayout()
        buttonTapped()
    }
    // MARK: - Layout
    func setupLayout() {
        
        [cancelBtn, titleLbl, saveBtn].forEach {
            titleStack.addArrangedSubview($0)
        }
        
        view.addSubview(titleStack)
        view.addSubview(tableView)
        
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    func buttonTapped() {
        cancelBtn.rx.tap.subscribe { [weak self] _ in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        saveBtn.rx.tap.subscribe { [weak self] _ in
            self?.dismiss(animated: true)
            if self?.viewModel.selectday.contains(1) == false {
                UserDefaults.standard.set(false, forKey: UserDefaultsKeys.writeSwitch.rawValue)
                for i in 0...6 {
                    self?.viewModel.selectday[i] = 1
                }
            }
            DayTimeViewModel.dayCheck.accept((self?.viewModel.selectday)!)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe { [weak self] item in
            self?.viewModel.dayimage(row: item.row)
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension DaySelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.DayArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayTableViewCell.identifier, for: indexPath) as? DayTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if viewModel.selectday[indexPath.row] != 0 {
            cell.check.isHidden = false
            cell.check.image = .check2
        } else {
            cell.check.isHidden = true
        }
        cell.dayLabel.text = viewModel.DayArr[indexPath.row]
        return cell
    }
}
