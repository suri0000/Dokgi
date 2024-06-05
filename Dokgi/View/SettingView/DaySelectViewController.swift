//
//  DaySelectViewController.swift
//  Dokgi
//
//  Created by 송정훈 on 6/5/24.
//

import UIKit

class DaySelectViewController : UIViewController {
    
    let cancelBtn = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor(named: "BrightRed"), for: .normal)
        $0.titleLabel?.font = Pretendard.regular.of(size: 17)
        $0.snp.makeConstraints {
            $0.width.equalTo(30)
        }
    }
    
    let titleLbl = UILabel().then {
        $0.text = "알림 요일 설정"
        $0.font = Pretendard.semibold.of(size: 20)
        $0.textAlignment = .center
    }
    
    let saveBtn = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(UIColor(named: "SkyBlue"), for: .normal)
        $0.titleLabel?.font = Pretendard.regular.of(size: 17)
        $0.snp.makeConstraints {
            $0.width.equalTo(30)
        }
    }
    
    let titleStack = UIStackView().then {
        $0.axis = .horizontal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let smallId = UISheetPresentationController.Detent.Identifier("small")
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: smallId) { context in
            return 390
            //390
        }
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [smallDetent ]
            sheetPresentationController.largestUndimmedDetentIdentifier = smallId
        }
        setupLayout()
    }
    
    func setupLayout() {
        
        [cancelBtn, titleLbl, saveBtn].forEach {
            titleStack.addArrangedSubview($0)
        }
        
        view.addSubview(titleStack)
        
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        
    }
}
